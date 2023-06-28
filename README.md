# inattention

This repository contains codes of the inattention paper '**How Does Inattention Influence the Robustness and Efficiency of Adaptive Procedures in the Context of Psychoacoustic Assessments via Smartphone?**'[1]

Author: Chen Xu, E-mail: chen.xu@uni-oldenburg.de

## How to use
- Figure3 and Figures4-6
The two folders provide the scripts to reproduce figures 3-6 in [1].

- exp_robustness
scripts to run numerical experiments for robustness comparison. 

- exp_efficiency
scripts to run numerical experiments for efficiency comparison. Each sub-folder corresponds to each adaptive procedure. Run run_*_m1.m for long-term inattention model while run run_*_m2.m for short-term inattention.


## External packages

- Updated maximum likelihood procedure
The codes were provided via [this link](https://hearlab.ss.uci.edu//UML/uml.html) [2]

- QuestPlus
The software was offered via [this link](https://github.com/petejonze/QuestPlus) [3]


# Publication 
[1] Xu, C., Hülsmeier, D., Buhl, M., & Kollmeier, B. (2023, June 26). How Does Inattention Influence the Robustness and Efficiency of Adaptive Procedures in the Context of Psychoacoustic Assessments via Smartphone?. https://doi.org/10.31234/osf.io/9ytd6

[2] Shen, Y., Dai, W., and Richards, V.M.(2014). “A MATLAB toolbox for the efficient estimation of the psychometric function using the updated maximum-likelihood adaptive procedure,” Behav. Res. Methods., 1-14.

[3] Jones, P. R. (2018). QuestPlus: a matlab implementation of the QUEST+ adaptive psychometric method. Journal of Open Research Software, 6(1).

# Acknowledgments
This work was funded by the Deutsche Forschungsgemeinschaft (DFG, German Research Foundation) under Germany's Excellence Strategy – EXC 2177/1 - Project ID 390895286. 
