%%=========================================================================
% Copyright © 2018, SoC Design Lab., Dong-A University. All Right Reserved.
%==========================================================================
% • Date       : 2018/08/06
% • Author     : Dat Ngo
% • Affiliation: SoC Design Lab. - Dong-A University
% • Design     : Local white balance
%==========================================================================

function [wb,light] = localWB(inImg,kfo4,kfo5,kfo6,balance,sv2)
%LOCALWB Perform local white balance.

if (size(inImg,3) ~= 3)
    warning('Input image must be an RGB image!');
    return;
else
    if (isinteger(inImg))
        input = double(inImg)/255 ; % Normalize input data 0 to 1
    else
        input = inImg;
    end
end

fo4 = kfo4*hmfm_v33_rgb(input,sv2);
nbfo4 = mean(fo4,3);
fo5 = kfo5*(fo4./nbfo4).^balance;
nbfo5 = mean(fo5,3);
light = kfo6*fo5./nbfo5;
wb = input./light;

end
