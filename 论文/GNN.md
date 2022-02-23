# Few-Shot Learning With Graph Neural Networks

使用图神经网络的小样本学习

## Abstract

我们提出研究在一个在局部观测图模型（partially observed graphical model）上使用推理棱镜（prim of inference）进行小样本学习的问题，该模型由一个输入图像集合构成，这些图像的标签可以被观测到也可以不被观测到。通过融合通用的消息传递推理（generic message-passing inference）算法与对应的神经网络，我们定义了一种图神经网络架构（graph neural network architecture），该架构泛化了最近提出的几个少数小样本学习模型。除了提供改进了的的数值性能外，我们的框架还可以轻松地扩展到小样本学习的变体（variants），如半监督或主动（active，或动态？）学习，还证明了基于图（graph-based）的模型能够很好地处理“关系”型（relational）任务。

## 1 Introduction

有监督的端到端（supervised end-to-end）学习在计算机视觉、语音或机器翻译任务中非常成功，这归功于优化（optimization）技术的改进、更大的数据集以及深度卷积架构或循环（recurrent）架构的改进设计。尽管取得了这些成功，但这种学习设定（setup）并没有涵盖许多仍然有可能和需要学习的方面。

其中一个例子就是在所谓的小样本学习任务中，从少量实例中学习的能力。受人类学习（human learning）Lake等人（2015）的启发，研究者们探索出了==利用类似任务分布（distribution of similar tasks）的方法，来替代正规化，以抵消（compensate）数据不足的影响==。这就定义了一种新的监督学习设置（也称为“元学习”），其中输入输出对不再由服从独立相似分布（iid）的图像样本与相关标签给定，而是由服从独立相似分布的图像集样本及相关标签的相似度给出（真绕啊）。

最近一个非常成功的研究项目在小样本图像分类任务上利用了这种元学习范式。（2015、2017年的两篇没见过，其他的就是孪生网络2015、匹配网络2016、原型网络2017）本质上，这些作品学习了一种上下文的（contextual）、任务具体（task-specific）的相似性度量（similarity measure），此类方法首先使用CNN嵌入（embed）输入图像，然后学习如何组合（combine）集合中的嵌入图像，以将标签信息传播（propagate）到目标图像。

特别是，Vinyals等人（2016年）将小样本学习问题转化为监督分类任务，将图像支持集映射到所需标签，并开发了一种端到端架构，通过注意机制（attention mechanisms）接受这些支持集作为输入。本工作中建立在上述一系列工作的基础（line）上，并认为这项任务自然地表达（expressed）为图上的监督插值问题（supervised interpolation problem on a graph），其中节点（nodes、顶点）与集合中的图像相关，边（edges）由可训练的相似核（trainable similarity kernels）给定。结合基于图结构数据的表征学习（representation learning）的最新进展Bronstein等人（2017年）；Gilmer等人（2017年）。由此提出了一个简单的基于图的小样本学习模型，该模型实现了任务驱动型信息传递（task-driven message passing）算法。最终的体系结构经过端到端的训练，捕获任务的不变性质（invariances），例如输入集内（样本）的排列顺序（permutations），并在简单性、通用性、性能和样本复杂性之间进行了良好的权衡。

除了小样本学习，另一个有关的任务是==从标记和未标记实例的混合中学习的能力-半监督学习==（这里理解一下，半并不是指一半的实例无标记，而是指存在无标记实例，与之相对的应该是全监督学习，即监督学习）以及==动态学习，其中学习器请求对预测任务最有帮助的缺失标签==。我们基于图的体系结构可自然地扩展到这些设置，只需对训练的设计进行极少的更改。我们在小样本图像分类上对模型进行了实验验证，以相当少的参数达到最先进的性能，并演示了它在半监督和动态学习设定中的应用。

我们的贡献总结如下：

- 我们将小样本学习转为一个监督性的消息传递任务（supervised message-passing task），使用图神经网络对它进行端到端的训练。
- 我们在Omniglot和MiniImagenet任务上使用更少的参数取得了最先进的性能。
- 我们将该模型推广到半监督和动态学习的体系中。

论文的其余部分结构如下：第2节介绍了相关工作，第3、4和5节介绍了问题设置、我们的图神经网络模型和训练，第6节报告了数值性实验。

## 2 Related Work

1-shot学习最早由Fei Fei et al.（2006）引入，他们认为当只有一个或几个标签可用的时候，当前训练的类别可以帮助预测新类别。最近，Lake等人（2015年）提出了一个分层贝叶斯模型（hierachiacal bayesian mdoel），该模型在小样本学字母任务中达到了人类水平的失误。

从那时起，在1-shot学习领域取得了巨大进展。Koch et al.（2015）提出了一个使用孪生网络计算成对样本间距离的深度学习模型，然后，该学习距离可用于通过KNN分类解决1-shot问题。Vinyals等人（2016年）提出了使用余弦距离的端到端可训练的KNN，他们还引入了使用attention LSTM模型的上下文机制（contextual mechanism），使得在成对计算样本之间的距离时考虑了子集T的所有样本。Snell et al.（2017）扩展了Vinyals et al.（2016）的工作，通过使用欧几里德距离而不是余弦距离，这带来了显著改进，他们还为小样本学习场景构建了每个类的原型表示（prototype representation）。Mehrotra& Dukkipati（2017）训练了一个带一个生成模型（generative model）的深度残差网络，来近似求解逐对样本之间的距离。

最近出现了一种新的针对1-shot学习的元学习器方法（line of meta-learners）：Ravi& Larochelle（2016年）引入了一种元学习方法，其中LSTM针对一个给定的episode，更新一个分类器的权重。Munkhdalai& Yu（2017）还提出了一种元学习架构，该架构跨任务（across tasks）学习元层面知识（meta-level knowledge），并通过快速参数化（fast parametrization）改变其归纳偏置（inductive bias）。Finn等人（2017年）正在使用一种基于梯度下降的模型无关型（model agnostic）元学习器，其目标是训练一种分类模型，以便在给定一项新任务时，带少量数据的几步梯度就足以泛化。最近，Mishra等人（2017）使用了时间卷积（temporal convolutions），这是一种基于加宽卷积（dilated convolutions）的深度递归（循环，recurrent）网络，该方法还利用了子集的上下文信息，提供了非常好的结果。

## 4 Model

本节介绍了我们的方法，一个基于简单端到端的图神经网络架构。我们首先解释了如何将输入上下文（input context）映射为图表示（graphical representation），然后详细介绍了该架构，然后展示了该模型如何泛化（generalize）先前发布的一些小样本学习架构。

### 4.2 Graph Neural Networks

图神经网络，最初由Gori等人（2005年）；Scarselli等人（2009年）引入，并在Li等人（2015年）；Duvenaud等人（2015年）中进一步简化；Sukhbatar等人（2016年）是一个基于图G=(V, E)的局部算子（local operators）的神经网络，在公式复杂度（expressivity）和样本复杂度（sample complexity）之间提供了强有力的平衡；参见Bronstein等人（2017年）关于图形深度学习模型和应用的最新调查。

