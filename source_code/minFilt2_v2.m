%%=========================================================================
% Copyright © 2018, SoC Design Lab., Dong-A University. All Right Reserved.
%==========================================================================
% • Date       : 2018/08/06
% • Author     : Dat Ngo
% • Affiliation: SoC Design Lab. - Dong-A University
% • Design     : 2-D Minimum Filter
%==========================================================================

function [minImg] = minFilt2_v2(inImg,sv2)
%MINFILT2 2-D minimum filter.
%   sv2: filtering window size.
%   slidingOp: sliding option, "sliding" or "distinct".

% Default parameters
switch nargin
    case 2
        % All arguments were provided, do nothing
    case 1
        sv2 = 5;
    otherwise
        warning('Please check input arguments!');
        return;
end

[~,~,c] = size(inImg);
padsize = floor((sv2-1)/2);
paddedImg = padarray(inImg,[padsize,padsize],Inf);
H = true(sv2,sv2);

switch c
    case 1 % grayscale image
        temp = ordfilt2(paddedImg,1,H);
        minImg = temp((sv2+1)/2:end-(sv2-1)/2,(sv2+1)/2:end-(sv2-1)/2);
    case 3 % RGB image
        temp = zeros(size(paddedImg));
        temp(:,:,1) = ordfilt2(paddedImg(:,:,1),1,H);
        temp(:,:,2) = ordfilt2(paddedImg(:,:,2),1,H);
        temp(:,:,3) = ordfilt2(paddedImg(:,:,3),1,H);
        minImg = temp((sv2+1)/2:end-(sv2-1)/2,(sv2+1)/2:end-(sv2-1)/2,:);
    otherwise
        warning('Invalid input image!');
        return;
end

end
