# HRwFE

## Note
I am unable to public the source code of Adaptive Tone Remapping (ATR) due to copyright restrictions. Thus, the dehazed results at this time are different from those being presented in the published paper. I will try my utmost to circumvent this issue.

## Summary
This source code is a MATLAB implementation of a haze removal algorithm that can deal with the post-dehazing false enlargement of white objects effectively. The following table summarized the main features of this algorithm.

Feature | Description
--------|------------
Background noise removal | The backgroud noise originated from the spike-like noise in the saturation channel. Thus, a simple low-pass filter removed the background noise effectively.
Color distortion correction | The employed linear regression model for estimating the scene depth misinterpreted dark regions as close regions, giving rise to the color distortion. HRwFE resolved this problem by an efficient means of adaptive weighting.
Post-dehazing false enlargement correction | The difference between the atmospheric light pixel and pixels surrounding white objects caused the post-dehazing false enlargement. HRwFE employed a compensation scheme that scales up the atmospheric light according to solve this problem.

Feel free to [contact me](mailto:ngodat9093@gmail.com) (<ngodat9093@gmail.com>) if you are interested in the hardware implementation of this dehazing algorithm.

## Run the code
Run the file "*demonstration_without_ATR.m*" in **MATLAB R2019a** to view the result. The source code is in the *source_code* folder.

## Qualitative results
![First](/results/qualitative_evaluation_1.jpg)
![Second](/results/qualitative_evaluation_2.jpg)
![Third](/results/qualitative_evaluation_all.jpg)
