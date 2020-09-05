# HRwFE (Source code will be uploaded soon)

## Summary
This source code is a MATLAB implementation of a haze removal algorithm that can deal with the post-dehazing false enlargement of white objects effectively. The following table summarized the main features of this algorithm.

Feature | Description
--------|------------
Background noise removal | The backgroud noise originated from the spike-like noise in the saturation channel. Thus, a simple low-pass filter removed the background noise effectively.
Color distortion correction | The employed linear regression model for estimating the scene depth misinterpreted dark regions as close regions, giving rise to the color distortion. HRwFE resolved this problem by an efficient means of adaptive weighting.
Post-dehazing false enlargement correction | The difference between the atmospheric light pixel and pixels surrounding white objects caused the post-dehazing false enlargement. HRwFE employed a compensation scheme that scales up the atmospheric light according to solve this problem.

## Qualitative results
