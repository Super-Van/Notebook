# Interventional Few-Shot Learning（2020）

## Abstract

我们发现了热门的小样本学习（FSL）方法中一个==曾被忽视的缺陷：预训练的知识确实是一个限制性能的confounder（干扰因素）。这一发现源于我们的casual assumption（因果假设）：即一个针对预训练的知识、样本特征和标签之间casualities（因果关系）的structural causal model（结构因果模型SCM）。==基于此，我们提出了一种新的FSL范式：Interventional Few-Shot Learning（介入式小样本学习IFSL）。具体而言，我们基于==backdoor adjustment==（后门调整）开发了三种可行的IFSL算法实现，这==本质上是对many-shot learning（多样本学习）的SCM的causal intervention（因果干预）==：因果视图中FSL的upper-bound（上界）。值得注意的是，IFSL的贡献与现有的基于fine-tuning和meta-learning的FSL方法是orthogonal（正交的，可以结合），因此IFSL可以（在原有基础上）改进这些方法，在miniImageNet、tieredImageNet和跨域CUB上实现1-shot与5-shot的最新性能。

## 1 Introduction

小样本学习（FSL）—使用极少量样本训练模型的任务—对于任何需要快速模型适应新任务的场景来说都是无可挑剔[64]，例如最小化reinforcement learning（强化学习）中高成本试验的需求[29]，为轻量级神经网络节省计算资源[26，24]。尽管我们知道，==十多年前，FSL的关键是模仿人类将prior knowledge（先验知识）转移到新任务的能力[17]，但直到最近预训练技术出现进步，我们才就“what & how to transfer（迁移什么及如何迁移）”达成共识：一个强大的神经网络Ω在一个大型数据集D上预训练==。事实上，从预训练中学到的先验知识促进了今天的深度学习时代。例如，视觉识别中D=ImageNet，Ω=ResNet[23,22]；NLP中D=Wikipedia，Ω=BERT[61,15]。

在预训练知识的背景中，我们将初始FSL训练集表示为support set S，将初始FSL测试集表示为query set Q，其中（S，Q）中的类在D中没有见过。然后，我们可以使用Ω作为backbone（主干网络）（参数固定或部分可训练）来提取sample representations，因此，只需在S上fine-tune目标模型并在Q上测试，即可实现FSL[11,16]。然而，==fine-tuning只利用了D关于“what to transfer”的知识，而忽略了“how to transfer”。==幸运的是，==后者的解决方法可以是应用post-pre-training（后预训练）和pre-fine-tuning（预微调）策略：即meta-learning（元学习）[52]。fine-tuning的目标是在S上训练“model”并在Q上测试，meta-learning的目标是学习“meta-model”—一种learning behavior—在从D中采样的许多learning episodes{（Si，Qi）}上进行训练，并在target task（S，Q）上进行测试==。特别是，可以通过φ，使用model parameter generator[46,19]或initialization[18]对behavior进行参数化。在元学习之后，我们将Ωφ表示为在后续target task（S，Q）上fine-tuning的new model starting point（新模型起点）。图1说明了上述FSL paradigms之间的关系。

众所周知，预训练的主干网络越强壮，downstream model会更好。然而我们惊奇地发现，在FSL中可能并不总是如此。如图2（a）所示，我们可以看到一个==悖论：尽管更强的主干网络平均而言提高了性能，但与S大不相同的Q样本上的性能确实降低了。==为了说明这种“不同”，我们在图2（b）中展示了一个5-shot学习示例，其中“绿草地”和“黄草地”的prior knowledge具有误导性。例如，Q中的“狮子”样本具有“黄草”，因此它们被错误分类为“狗”，S中狗样本主体为“黄草”。如果我们使用更强的Ω, 已见过的old knowledge（“草”及其“颜色”）将比还没见过的new knowledge（“狮子”和“狗”）更robust（强壮，意即背景在颜色面积上占得比重更大？），因此旧知识变得更具误导性。我们认为，这种悖论揭示了FSL中未知的系统性缺陷，但多年来，我们的gold-standard "fair" accuracy（金科玉律 公平正确率）一直掩盖着这一缺陷，在所有随机取的（S，Q）试验中算平均正确率，而不管S和Q之间的相似性如何（参见图2（a））。尽管图2仅仅说明了fine-tune FSL paradigm，但元学习范式中存在缺陷，因为fine-tune也用于每个meta-train episode（图1所示）。我们将在第5节中对其进行深入分析。

在本文中，我们首先指出了==缺陷的原因：pre-training可能会在FSL中产生不良影响==，然后提出了一种新的FSL范式：介入性小样本学习（IFSL），以对抗不良影响。我们的理论基于pre-trained knowledge、few-shot samples和class labels之间的causalities（因果关系）的假设。具体而言，我们的贡献总结如下：

- 我们从第2.2节中的==structural causal model（SCM）假设开始，当中阐明pre-trained knowledge本质上是一个confounder（混合因素，干扰因素），导致support set中的sample features和class labels之间存在spurious correlations（虚假相关性）。==正如图2（b）所示的直观示例，即使“草”feature不是“狮子”label的诱因，但“草”的prior knowledge仍然会confound（干扰、混淆）classifier去learn它们之间的correlation（相关性）。

- 在第2.3节中，我们阐述了==为什么我们提出的IFSL从根本上更有效：它本质上是对many-shot learning的causal approximation（因果近似）。==这促使我们利用第3节中的backdoor adjustment[44]开发三种IFSL的有效实现。

- ==得益于causal intervention（因果干预），IFSL自然而然与基于downstream fine-tuning和meta-learning的FSL方法正交==[18、62、27]。在第5.2节中，IFSL以相当大的幅度改进了所有baselines，实现了最新的1/5-shot性能：miniImageNet上[62]为73.51%/83.21%，tieredImageNet[49]为83.07%/88.69%，cross-domain的CUB[65]为50.71%/64.43%。
- 我们进一步推断了FSL方法在S和Q之间的不相似性方面的具体性能。我们发现，IFSL在每inch都优于所有baselines。

## 2 Problem Formulations

### 2.1 Few-Shot Learning

我们对一个prototypical FSL感兴趣：在N-shot的support set S上训练一个K-way分类器，其中N指每个类的少量训练样本（比如N=1或5）；然后在query set Q上测试分类器。如图1所示，我们有以下两种范式来训练classifier P（y | x；θ） ，预测sample x的类别y∈ {1,...,K}：

- **fine-tuning**。我们将prior knowledge作为sample feature representation X，它是由在数据集D上预训练过的的网络Ω编码得到的 。特别地，我们将x指定为的Ω的frozen sub-part（冻结子部分）的输出，那么Ω剩余可训练的sub-part  (如果有）可以被absorbed（并入）θ中。==我们在support set S上训练分类器P（y | x；θ） 然后以标准的监督方式在query set Q上对其进行评估。==
- **meta-learning**。但是，Ω 仅以“representation”的方式carries（携带）先验知识。如果==数据集D可以重新组织成training episodes{（Si，Qi）}的形式，则每个training episode都可以被视为一个“sadbox（沙盒）”，其具有与target（S，Q）相同的N-shot-K-way设定。==然后，我们可以从通过参数φ对来自D中的“learning behavior”进行建模，即通过上述fine-tuning范式对针每个（Si，Qi）进行学习。形式上，==我们用Pφ（y | x；θ） 作为具有learning behavior的增强型分类器==。例如，φ可以是classifier weight generator[19，此论文用一个叫gnn去噪自编码器生成权重]，或kNN中的distance kernel function（距离核函数）[62]，甚至θ的初始化[18]。将Lφ（Si，Qi；θ）定义为为Pφ（y | x；θ）的损失函数，在Si上训练在Qi上测试，我们有<公式省略>，然后==我们确定优化好的φ并在S上对θ进行微调，然后在Q上进行测试==。有关各种微调和元学习设置的详细信息，请参阅附录5。

### 2.2 ==Structural Causal Model==

从上面的讨论中，我们可以看到meta-learning中的（φ，θ）和fine-tuning中的θ都依赖于pre-training。这种“dependency”可以用图3（a）中提出的结构因果模型（SCM）[44]形式化，其中节点表示抽象数据变量，有向边表示（functional）casuality，如X→Y表示X是cause（原因），Y是effect（结果）。现在，我们从一个high-level介绍此graph及其construction背后的rationale（基本原理）。有关详细的functional implementations（功能实现），请参见第3节。

**D→X** 我们用X表示特征表示，D为pre-trained knowledge，如数据集D及其induced model Ω. 这条链路表名使用Ω提取feature X. 

**D→C←X** 我们将C表示为low-dimensional manifold（低维流形）中的transformed representation X，其base继承自D。这一假设可rationalized（合理化）如下。

- D→C：一组data points（数据点）通常被embbed（嵌入）在低维流形中。这一发现可以追溯到dimensionality reduction（降维）的漫长历史中[59,50]。目前，有理论上[3,8]和经验上的[77,71]证据表明，训练深层网络过程中会出现disentangled semantic manifolds（分离语义流形）。
- X→C：features可以使用manifold base linearly[60,9] or non-linearly[6]（线性或非线性流形基底来）表示，或投影到后者上。特别地，在稍后第3节也会讨论，我们显式地将base实现为feature dimension（图3（b））和class-specific mean features（具体到某个类的平均特征）（图3（c））。

**X→Y←C**我们将Y表示为classification effect（分类结果）（如logits，概率分布最大值和下标），由X通过两种方式确定：1）直接X→ Y和 2）带中介的 X→C→Y。特别地，如果X可以用C完全represent（表示）（如第3节中的feature-wise adjustment，根据特征的调整），则可以删除第一种方式。第二种方法是一定存在的，即使分类器不将C视作explicit input（显式输入），因为任何X都可以由C inherently（固有地、本质地）表示。为了说明这一点，假设X是两个基向量加上噪声残差的线性组合：X＝c1b1+c2b2+e，任何分类器f（X）＝f（c1b1+c2b2+e）将关于b1和b2隐式利用C representation。事实上，这一假设也从根本上验证了unsupervised representation learning（无监督表征学习）[5]。为了看出这一点，如果在图3（a）中C→Y断了，那么从P（Y | X）中发现latent knowledge representation（潜在知识表示）是不可能的，因为剩下的唯一路径即将knowledge从Dtransfer到Y：D→X→Y，已经被conditioning on X（X上的训练、调节）切断了，即D→X断了。

一个理想的FSL模型应该捕捉X和Y之间的true casuality（真实因果关系），泛化到unseen samples。如刚才的图2（b）所示，我们期望“狮子”的预测是由“狮子”的feature perse（特征本身）cause（诱导、推导）的，而不是背景“草”。然而，从图3（a）中的SCM来看，传统的correlation（相关性）P（Y | X）无法做到这一点，因为给定X条件下Y的increased likelihood（增强型概率）不仅仅来源于“X cause Y”，体现在X→Y和X→C→Y，还可以来源于spurious correlation（伪相关）：1）D→X，如“草”的knowledge生成了“草”的feature，2）D→C→Y，如“草”的knowledge生成了“草”的semantic（语义），为“狮子”label提供了有用的context。因此，为了追求X和Y之间的真实因果关系，我们需要使用causal intervention（因果干预）P（Y | do（X））[45]，而不是针对FSL objective的likelihood P（Y | X）。

### 2.3 Causal Intervention via Backdoor Adjustment

至此，细心的读者可能会注意到，图3（a）中的causal graph（因果图）也适用于many-shot learning（MSL），如基于预训练的conventional learning。==与FSL相比，MSL的P（Y | X）估计更为robust（稳健）==。例如，在miniImageNet上，5-way 550-shot 微调的分类器可以达到95%的准确率，而5-way 5-shot 微调的分类器只能达到79%。我们过去常常根据点估计中的大数定律将FSL的低性能归咎于[14]数据不足。然而，它不能回答为什么MSL会随着样本数量的无限增加而收敛到true causal effects。换句话说，为什么P（Y | do（X））≈ MSL中的P（Y | X）而P（Y | do（X））不≈ FSL中的P（Y | X）？

为了回答这个问题，我们需要结合endogenous feature（内源性特征）将采样x∼ P（X | I）转化为P（Y | X）的估计，其中I表示样本ID。我们有P（Y | X=xi）：=Ex∼P（X | I）P（Y | X=X，I=I）=P（Y | I），也就是说==我们可以用P（Y | I）来估计P（Y | X）==。在图4（a）中，I和X之间的因果关系纯粹是I→X,。X→I不存在，因为从各类多样本中跟踪X的ID就像大海捞针，因为DNN（深度神经网络）的特征是许多样本的abstract and diversity-reduced的representation[21]。然而，如图4（b）所示，X→I在FSL中一直存在，因为模型更容易“guess” correspondence（对应关系），例如，极端情况1-shot产生X↔I的1-to-1 mapping。 因此，正如我们在附录1中形式化展示的，MSL和FSL之间的主要causal difference是：==MSL从本质上使I成为instrumental variable（机械变量）[1]，以实现P（Y | X）：=P（Y | I）≈ P（Y | do（X））。直观地说，我们可以看到MSL中I和D之间的所有因果关系都被阻断，从而使I和D相互独立。因此，feature X本质上是由I“intervened（干预）”的，不再由D支配。==例如，图2（b）中的“黄草”和“绿草”都不再支配“狮子”，通过控制pre-trained knowledge的使用来模仿casual intervention（随机干预）。

在本文中，我们提出==使用backdoor adjustment[44]来实现P（Y | do（X）），而不需要many-shot，这当然会破坏FSL的定义。后门调整假设我们可以对confounder进行观察和stratify（分层），即令D={d}，其中每个d是预训练知识的stratification（分层）。==formally（公式化的话），如附录2所示，图3（a）中graph的后门调整为：

其中g是稍后会定义的函数。然而，instantiate（实例化）d并不是件小事，特别是当D是第三方交付的预训练网络，数据集是unobserved（不可观测的）[20]。接下来，我们将针对IFSL提供等式（1）的三种practical implementations（可行实现）。

## 3 ==Interventional Few-Shot Learning==

我们的实现思想受到每个经预训练的深度神经网络的两个固有属性的启发。首先，每个特征维度都carries（携带、承载着）一个semantic meaning（语义），例如，众所周知，卷积神经网络中的每个channel都encode visual concepts（对视觉概念进行编码）[77,71]。因此，每个特征维度（特征的某一个维度）代表一条知识。其次，大多数流行的预训练模型使用分类任务作为目标，例如ResNet的1000-way 分类器[23]和BERT的token predictior（令牌预测器）[15]。因此，分类器可以被视为distilled（提取、提纯的）知识，这在文献[24]中已经被广泛采用。接下来，我们将通过为等式（1）中的g（x，d）、P（Y |X，D，C）和P（D）提供三种不同的实现来详细说明所提出的interventional FSL（IFSL）。特别是，附录5给出了不同分类器中P（Y |·）的exact forms（确切形式）。

**Feature-wise Adjustment**（根据特征的调整，特征调整）。假设F是x的特征维数的索引集。例如，从预训练网络Ω的最后一层来看. 我们将F划分为n个等距的disjoint subsets（不相交子集），如ResNet-10的输出特征维数为512，如果n=8，则第i组将是尺寸为512/8=64的特征维度索引集，即Fi={64（(i − 1)+ 1, . . . ,64i}。预训练知识的stratum set（层次集）定义为D:={d1,...,dn}，所以其中每个di=Fi。

......

值得注意的是，特征调整始终适用，因为我们始终可以从预先训练的网络中获得特征表示x。有趣的是，我们特征调整为transformers中的multi-head trick（多头技巧）提供了些微的理论依据[61]。我们将在今后的工作中探索这一点。

## 4 Related Work

**Few-Shot Learning** FSL有多种方法，==包括fine-tuning[11,16]，optimizing model initialization（优化模型初始化）[18,40]，generating model parameters（生成模型参数）[51,34]，learning feature space以更好地实现样本categories（类别）的separation（分离）[62,72]，feature transfer（特征转移）[54,41]，以及另外使用query set data的transductive learning[16,27,25]==。多亏了它们，分类准确率大大提高了[27,72,68,35]。然而，作为一个single number（单纯一个孤立数字）的准确度无法解释图2中的paradoxical（矛盾）现象。我们的工作从causal角度提供了一个答案，表明预训练是一个confounder。我们不仅进一步提高了各种FSL方法的正确率，还解释了改进背后的原因。事实上，我们的工作提供的视角可以使所有涉及预训练的任务受益。与大规模预训练数据相比，任何downstream（下游）task都可以被视为FSL。

**Negative Transfer** 上述现象也被称为负迁移，==source domain（源域）的学习对target domain（目标域）的性能产生负面影响==[42]。许多研究工作都集中在何时以及如何进行这种transfer learning（迁移学习）[28,4,76]。Y osinski等人[69]根据人造对象和自然对象划分了ImageNet，作为feature transferability（特征的可迁移性）的试验台。它们resemble（模拟了） 图2（a）中使用的S 不∼Q（S不相似于Q的）设置。其他工作还表明，==当训练和测试之间的domain gap（域差异）较大时，使用更深的主干网络可能会导致性能的下降==[31]。在小样本设置[47]和NLP任务[58]中报告了一些类似的发现。==不幸的是，他们没有从理论上解释为什么会发生这种情况。==

**Causal Inference** 我们的工作旨在==基于因果推理处理FSL里的预训练confounder==[45]。因果推理最近被引入机器学习[38,7]，并已应用于计算机视觉的各个领域[67]。提出了图像字幕的回顾以及其他应用包括图像分类[10,36]、imitation learning（模仿学习）[13]、long-tailed recognition（长尾识别）[56]和semantic segmentation（语义分割）[73]。==我们是第一个从因果关系的角度探讨FSL的人==。我们想强调的是，==基于data-augmentation（数据增强）的FSL也可以被视为近似的intervention（干预）。这些方法学习使用图像deformation（变形）[12,74]或generative models（生成性模型）[2,75]生成额外的support样本。这可以看作是对图像特征的physical interventions（物理干预）==。关于图像X和标签Y之间的causal relation（因果关系），一些作品采用了anti-causal learning（反因果学习，即果因学习）[39]，即。Y→X，其中，假设标签Y被disentangled（分离）到足以被视为independent mechanism（独立机制）（IM）[43，55]，其通过Y→X生成可观测的图像X。然而，我们的工作目标在于在更一般的情况，即标签可以be entangled（纠缠、混杂）（例如"狮子”和“狗”都有“软毛”的语义）于是IM假设可能不成立。因此，我们使用因果预测X→Y因为它本质上是一个reasoning process（推理过程），其中IM被D捕获，D被设计通过CNN（如卷积操作是独立应用的）分解。这样，D通过D→X生成visual feature（视觉特征）并通过D→Y仿真人类的命名过程（如 "毛皮“、“四条腿”→“猫鼬”）。事实上，causal direction（因果方向）X→Y（不是反因果的Y→X）已经在复杂的CV任务中得到了经验性证明[30,63,56,57]。
