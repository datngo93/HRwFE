%%=========================================================================
% Copyright © 2018, SoC Design Lab., Dong-A University. All Right Reserved.
%==========================================================================
% • Date       : 2018/08/31
% • Author     : Dat Ngo
% • Affiliation: SoC Design Lab. - Dong-A University
% • Design     : 2-D Mean Filter with coefficients
%                H: filter coefficients.
%==========================================================================

function [meanImg] = weightedMeanFilt2(inImg,H)

% Default parameters
switch nargin
    case 2
        % All arguments were provided, do nothing
    case 1
        H = ones(3)/9; % default 3x3
    otherwise
        warning('Please check input arguments!');
        return;
end

[~,~,c] = size(inImg);
sv2 = size(H,1);
paddedImg = sympad(inImg,sv2);

switch c
    case 1 % grayscale image
        temp = colfilt(paddedImg,[sv2,sv2],'sliding',@weightedMean);
        meanImg = temp((sv2+1)/2:end-(sv2-1)/2,(sv2+1)/2:end-(sv2-1)/2);
    case 3 % RGB image
        temp = zeros(size(paddedImg));
        temp(:,:,1) = colfilt(paddedImg(:,:,1),[sv2,sv2],'sliding',@weightedMean);
        temp(:,:,2) = colfilt(paddedImg(:,:,2),[sv2,sv2],'sliding',@weightedMean);
        temp(:,:,3) = colfilt(paddedImg(:,:,3),[sv2,sv2],'sliding',@weightedMean);
        meanImg = temp((sv2+1)/2:end-(sv2-1)/2,(sv2+1)/2:end-(sv2-1)/2,:);
    otherwise
        warning('Invalid input image!');
        return;
end

    % Weighted mean function
    function wm = weightedMean(in)
        width = size(in,2);
        mask = repmat(H(:),[1,width]);
        wm = sum(in.*mask,1);
    end

end
