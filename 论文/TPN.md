# 学习传播标签：用于小样本学习的转导传播网络（2019）

## 摘要

小样本学习的目标是学习一个分类器，此分类器即使在训练每个类的训练

实例数量有限的情况下，也能很好地泛化。最近引入（提出）的元学习方法通过在大量多类别分类任务中学习一个generic分类器并将模型泛化（推广）到一个新的任务来解决这个问题。然而，即使有了这样的元学习，新的分类任务中的low-data问题仍然存在（过拟合，性能不够好）。在本文中，我们提出了Transductive Propagation Network(TPN)-转导传播网络，一个新的针对==transductive inference==的元学习框架，==它一次性为整个测试集作分类，以缓解低数据问题。具体来说，我们提出：通过利用数据中的manifold structure学习出一个graph construction module，以学习将标签从有标签的实例传播到无标签的测试实例（learn to propagate labels）。TPN以end-to-end（端到端）的方式jointly learns（联合学习）feature embedding和graph construction的参数。==我们在多个benchmark datasets（基准数据集）上检验了TPN的效果，结果表明它大大优于现有的小样本学习方法，取得了最先进的结果。

## 1. Introduction

深度学习的最新突破(2012、2015、2016)高度依赖大量可用的标记数据。然而，这种对大数据的依赖增加了数据收集的负担，这阻碍了深度学习在low-data regime中的潜在应用，在低数据体系中，标记数据很少且难以收集。相反，人类在观察一个或几个实例后就能识别新物体(2011)。例如，孩子们可以在给出一个“苹果”的例子后就能概括出“苹果”的概念。人类与深度学习之间的这种显著差异重新唤起了对小样本学习的研究兴趣(2016、2017、2018)。小样本学习的目的是学习一个分类器，每个类给定几个例子的条件下它也可以很好地泛化。传统技术如微调(2014)可以很好地与深度学习模型合作，但会==严重使得某项任务过拟合(2016、2017)，因为单个或几个带标签的实例不能准确反映真实的数据分布，即导致学习出高方差的分类器，就不能很好地泛化到新数据。==为了解决这个过拟合问题，Vinyals et al.(2016)提出了一种元学习策略，该策略基于大量的episodes学习不同的分类任务，而不是只学习目标分类任务。在每一个episode中，算法学习少数带标记实例(support set)的embedding，然后通过embedding space中的距离用来预测未标记点(query set)。episodic training的目的是模拟包括小样本support set和未标记query set在内的真实环境。训练环境与测试环境的一致性减轻了distribution gap（分布差距），提高了泛化能力。这种episodic元学习策略，由于其不错的泛化性能，已被许多后续研究所采用。Finn et al.(2017)学习了能够快速适应目标任务的良好初始化（参数）。Snell等人(2017)利用episodes训练一个好的representation，并通过计算与类原型之间的欧几里德距离来预测类别。

虽然episodic strategy是一种有效的小样本学习方法，因为它的目标是泛化到前所未见的分类任务，但对于一种新的分类任务来说，在缺乏数据的情况下学习的基本困难仍然存在。==基于有限的训练数据实现更大改进的一种方法是考虑测试集中实例之间的关系，从而从整体上预测它们，这被称为转导，或转导推理。==在以前的工作中(Joachims, 1999;周等，2004;V apnik, 1999)，转导推理已经证明优于归纳方法，后者是逐一地预测测试示例，特别是在小的训练集。一种常用的转导方法是在标记数据和未标记数据上建立一个网络，并在它们之间传播标记，来进行joint prediction（联合预测）。然而，这种标签传播(和转导)的主要挑战是，标签传播网络往往不考虑主要任务，因为不可能在测试时学习它们。

但是，借助episodic training的元学习，我们可以学习label propagation network（标签传播网络），因为从训练集中采样的query实例可以用来仿真测试集进行transductive inference。受此发现启发，我们提出了转导传播网络(TPN)来处理低数据问题。我们没有使用inductive inference，而是使用整个查询集进行transductive inference(见图1)。具体来说，我们首先使用深度神经网络将输入映射到一个embedding space。然后，基于support set和query set的并集，构造一个graph construction module以利用新类空间的manifold structure。根据graph structure（图结构），采用迭代的label propagation将标签从support set传播到query set，最终得到一个closed-form solution（封闭解）。利用query set的propagated scores和ground truth标签，我们计算了关于feature embedding的交叉熵损失和graph construction parameters。最后，所有参数都可以通过反向传播进行端到端地更新。

本工作的主要贡献有三个方面：

- 据我们所知，我们是==第一批在小样本学习中明确地将transductive inference模型化==的人。尽管Nichol等人(2018)利用transductive setting做了实验，但他们仅通过batch normalization在测试样本之间share informatiion，而非直接提出一个transductive model。
- 在transductive inference中，针对未见过的类别，我们提出通过episodic meta-learning来在数据实例之间learn to propagate labels。学习出来的label propagation graph被证明明显优于简单的heuristic-based label propagation methods。
- 我们在两个基准数据集上评估了我们的方法，即miniImageNet和tieredImageNet。实验结果表明，我们的TPN在这两个数据集上都优于最新的方法。此外，通过半监督学习，我们的算法获得了更高的性能，优于所有现有的semi-supervised few-shot learning baselines。

## 2. Related Work

### meta-learning

在最近的研究中，小样本学习经常遵循元学习的思想(Schmidhuber, 1987;Thrun and Pratt, 2012)。元学习试图基于batches of tasks进行优化，而不是batches of data points。每个任务对应一个learning problem，在这些任务上获得良好的性能有助于快速学习并很好地推广到目标小样本问题，且不会遭遇overfitting。著名的MAML方法(Finn et al.， 2017)旨在寻找transferable representations with sensitive parameters。Nichol et al.(2018)提出了一种名为Reptile的first-order（一阶）元学习方法。它与一阶MAML密切相关，但不需要对每个任务进行training-test划分（即无support set-query set划分）。与上述方法相比，==我们的算法对在query points上的label propagation有一个closed-form solution，因而避免了内部更新中的梯度计算，且通常执行效率更高。==

### embedding and metric learning approaches

另一类的小样本学习方法旨在通过metric learning方法优化transferable embedding。匹配网络(Vinyals et al.， 2016)在给定support set的条件下产生一个weighted nearest neighbor classifier，并根据query set上的性能调整feature embedding。原型网络(Snell et al.， 2017)首先计算class‘s prototype，即在embedding space中support set的平均值。然后通过寻找与embedded query points最近的类原型来评估feature embedding的可移植性。Ren等人(2018)提出了一种==原型网络的扩展，即处理半监督的小样本学习==。关系网络(Sung et al.， 2018)learns to learn一个deep distance metric，以比较episodes里的的少量图像。==在某种意义上我们提出的方法与这些方法相似，该意义是指我们都着重学习具有良好泛化能力的deep embeddings。==然而，==我们的算法假设了一个transductive setting，在此项设置中，我们基于support set和query set的并集，使用episodic-wise parameters挖掘manifold structure of novel class space。==

### Transduction

transductive inference的设定最早是由Vapnik (Vapnik, 1999)提出的。TSVMs (Joachims, 1999)是一种margin-based（基于边界）的分类方法，旨在将特定测试集的误差最小化。相较于inductive methods它有本质上的大改进，特别是对于小的训练集。另一类transduction methods涉及到graph-based methods(Zhou et al.， 2004;Wang和Zhang, 2006;Rohrbach等人，2013;Fu等人，2015，Zhou et al.2004)利用标签传播，在weighted graph（加权图）的引导下，将标签从标记数据实例transfer（转移）到无标记数据实例。标签传播对variance parameter σ较为敏感，因此linear neighbor propagation（线性邻域传播，LNP) (Wang and Zhang, 2006)构造了近似的laplacian matrix（拉普拉斯矩阵）来避免这一问题。在Zhu和Ghahramani(2002)的文章中，用minimum spaning tree（最小生成树）heuristic and entropy minimization来学习参数σ。在所有这些之前的工作中，graph construction是在一个预定义的feature spacing上使用手动选择的超参数完成的，因为不可能在测试时学习超参数。另一方面，我们的方法能够学习graph construction network，因为它是一个带episodic training的元学习框架，在每个episode中，我们用训练集的一个子集来模拟测试集。

在小样本学习中，Nichol等人(2018)使用transductive setting进行实验，结果大有改进。然而，它们仅通过BN在测试实例之间共享信息(Ioffe和Szegedy, 2015)，而不是像我们的算法那样显式地model the transductive setting（对转导设置进行建模）。

后续见手写笔记

