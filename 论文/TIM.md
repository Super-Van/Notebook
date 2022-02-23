# 用于小样本的转导信息最大化（2020）

## 摘要

我们引入Transductive Information Maximization(TIM)用于小样本学习。对于给定的小样本任务，我们的方法==最大化了query features和它们的标签预测之间的mutual information（交互信息）==，并结合了基于support set的supervision loss（监督损失）。此外，我们==为我们的mutual-information loss提出了一个新的alternative-direction solver，它大大加快了gradient-based optimization的transductive inference convergence，同时产生了相当的精度（结果相似，但速度更高）。==TIM inference是modular（模块化的，可复用、通用）:它可以在任何base-training feature extractor上使用。遵循标准的transductive小样本设定，我们的综合实验表明，TIM在各种数据集和大网络上的性能明显优于最先进的方法，同时它被用在固定的特征提取器上，该提取器在基类上用简单的交叉熵训练，而无需求助于复杂的元学习方案。与最新性能最好的方法相比，它总能带来2%至5%的准确性提升，无论所有公认的小样本基准数据集测试，还是更具挑战性的场景-数据域切换和类别数增加。

## 1 Introduction

深度学习模型取得了空前的成功，它在大规模标记数据上训练时，达到接近人类水平的表现。然而，当处理新的(看不见的)类时，这种模型的泛化可能会受到严重挑战，因为每个类只有几个标记的实例。然而，人类则可以通过利用上下文和prior（先验）知识，从少量实例中快速学习新的任务。小样本学习(FSL)范式试图填补这一差距，最近吸引了大量的研究兴趣，最近产生大量的研究工作，例如……。在小样本设置中，首先在基类带标记数据上训练模型。然后，在训练过程中未见过的新类未标记样本(query set)组成的小样本任务上评估模型泛化，假定每个新类只给出一个或几个标记样本(support set)。

FSL框架内的大多数现有方法基于“learning to learn”范式或元学习，其中训练集被视为一系列平衡的任务(或episodes)，以便模拟测试期场景。流行的作品包括原型网络，它用embedding prototype描述每个类，并通过episodic training求解query samples的最大log-probability；匹配网络，它将对query的预测表示为support labels的linear combinations（线性组合），并借助memory architectures采用episodic training；MAML，一个元学习器，训练模型使其“容易”fine-tune；LSTM meta-learnner，它提出将优化作为小样本学习的模型。最近有大量元学习工作正在跟进，仅举几个例子……。

### 1.1 Related work

transductive inference：在最近的一系列工作中，transductive inference已经成为处理小样本任务的一种极具吸引力的方法[7，14，19，28，34，32，27，51]这些文章展现出了优于inductive inference的性能。==在transductive 设定中，模型一次性对单个小样本任务的所有未标记query实例进行分类，而不是像归纳方法那样一次仅对单个样本进行分类。==最近这些在小样本学习中的实验观测与经典的transductive inference中的既有事实一致[44，18，6]，众所周知，transductive inference在小规模的训练集上优于归纳方法。虽然[32]通过batch normalization（批量归一化）使用未标记的query样本的信息，但[28]（TPN）的作者是第一个在小样本学习中将transductive inference显式建模的人。受很流行的label-propagation概念[6]启发，他们构建了一个元学习框架，通过一个图来学习将标签从有标签的实例传播到无标签的实例。文献[14]（CAN）中的元学习transductive方法使用attention mechanism将标签传播给未标记的query样本。与我们的工作更密切相关的是，最近Dhillion等人[7]（baseline，不是讲过的new baseline）提出的transductive inference在未标记query样本上最小化网络softmax预测的entropy，报告了很有竞争力的few-shot性能，同时在基类上使用标准的交叉熵训练。[7]的有竞争力的性能与最近的几个归纳基线[5，46，41]处统一水平线，这些基线报告了对基类的标准交叉熵训练匹配，超过了更为复杂的元学习过程的性能。此外，在熵最小化被广泛使用的半监督学习的背景下，文献[7]的性能与既有结果大致相同[11，31，2]。值得注意的是，transductive方法的inference runtime通常比inductive方法长得多。例如，[7]的作者在inference过程中对深度网络的所有参数进行了fine-tune，这比ProtoNet（原型网络）[38]等归纳方法慢了几个数量级。此外，基于matrix inversion（求矩阵的逆），文献[28]中的transductive inference在query样本数量上具有三次方的复杂度。

Info-max principle（信息最大化原则）：[11,7]中的半监督和小样本学习建立在Barlow的entropy minimization（熵最小化）原则[1]的基础上时，==我们的few-shot formulation受到了Linsker所[25]阐述的通用info-max principle（信息最大化原理）的启发，形式上由系统输入和输出之间最大化的mutual information（MI）组成。在我们的情境中，输入是query features，输出是它们的标签预测。==这个想法也与context of clustering（聚类上下文、聚类背景）中的info-max有关[21，16，17]。更普遍地说，在通信领域已投入建设的info-max principle最近被用于一些deep-learning问题，例如representation learning[13,43]、metric learning[3]或domain adaptation[24]等一些问题。

### 1.2 Contributions

我们提出了用于小样本学习的传导（直推）信息最大化（TIM）。我们的方法==最大化了query特征和它们的标签预测之间的MI（交互信息），同时最小化了support set上的交叉熵损失。==

我们==针对损失得出一个alternating-direction solver，它让transductive inference的速度大大由于基于梯度的优化，同时产生具有竞争力的正确率。==

在标准的transductive 小样本设定下，我们的综合评估显示，TIM在各种数据集和网络上的表现明显优于最先进的方法（网络和数据集可以用在各种方法模型中），而只需在基类上使用简单的交叉熵训练，且没有复杂艰涩的元学习方案。与目前性能最佳的方法相比，它始终能提高2%到5%的准确度，这种提升不仅体现在所有现有的小图标基准集上，也体现在更具挑战性的、最近引入的场景中，如domain shifts（域转换、跨域、跨数据集）和类别的增多（n值的增大）。有趣的是，==我们的MI loss包括一个label-marginal regularizer，它有一个明显的作用：在正确率上带来本质性改进，同时faciliate optimization（加速、促进优化过程）==，使transductive runtimes减少几个数量级。

## 2 Transductive Information Maximizaiton

见手写笔记

