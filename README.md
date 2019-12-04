
This repository holds the MATLAB code to download and analyze the results in the paper:

**"On-board communication-based relative localization for collision avoidance in Micro Air Vehicle teams"**.
*Mario Coppola, Kimberly N. McGuire, Kirk Y. W. Scheper, Guido C. H. E. de Croon, 2018.*
Autonomous Robots, December 2018, Volume 42, Issue 8, pp 1787–1805

The paper is available open-access at this link: 
https://link.springer.com/article/10.1007/s10514-018-9760-3

Or use the following link for a PDF:
https://link.springer.com/content/pdf/10.1007%2Fs10514-018-9760-3.pdf

To download the data used in the paper, use the script `download_data.sh', or do it manually by following the instructions on top of the script. The data is needed to reproduce the plots as in the paper.

To run and reproduce the results, the following MATLAB scripts can be used:

* `histplots_all.m`
Reproduces the histograms as seen in the results section of the paper, based on the data.
* `errorplots_optitrack.m`
Reproduces the plots and data analysis used in the results section of the paper, when optitrack is used for control
* `errorplots_autonomous.m`
Reproduces the plots and data analysis used in the results section of the paper, when the drones use their on-board estimation and controllers completely
* `cone_size_analysis.m`
Produces the figures which show the influnce of parameters on cone size
* `stdma_analysis.m`
Reproduces the figures showing the messaging rate of STDMA, as seen early in the paper
* `preliminary_flight_results_analysis.m`
Reproduces the preliminary results with an off-board EKF used in the early stages of the research as proof of concept. The results are similar to those shown earlier in the paper, albeit the performance of the EKF can vary on each run due its stochastic nature.
* `preliminary_lobe_tests_analysis.m`
Reproduces the results of the preliminary tests to better understand the correlation of Bluetooth RSSI with distance and the impact with lobes.
