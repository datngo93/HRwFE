%%=========================================================================
% Copyright © 2018, SoC Design Lab., Dong-A University. All Right Reserved.
%==========================================================================
% • Date       : 2018/04/05
% • Author     : Dat Ngo
% • Affiliation: SoC Design Lab. - Dong-A University
% • Design     : Hybrid median filter implementation (ver. 3)
%==========================================================================
function hm = hmfm_v33(input,sv)

% Boundary extension
% input_pad = padarray(input, [floor(sv/2) floor(sv/2)], 'symmetric');
input_pad = sympad(input,sv);

% Square mask
square = true(sv,sv);

% Cross mask
cross = false(sv,sv);
cross((sv+1)/2,:) = true;
cross(:,(sv+1)/2) = true;

% Diagonal mask
diag = false(sv,sv);
diag((1:sv)+sv*(0:sv-1)) = true;
diag((1:sv)+sv*((sv-1):-1:0)) = true;

% Filtering
hmtemp = hybridMedfilt(input_pad);

% Return orginal size
hm = hmtemp((sv+1)/2:end-(sv-1)/2,(sv+1)/2:end-(sv-1)/2);

    % Hybrid median filter
    function hm = hybridMedfilt(inImg)
        
        [h,w,c] = size(inImg);
        hm = zeros(h,w,c);

        % Filtering
        for index = 1:c
            hm1 = ordfilt2(inImg(:,:,index),(sv*sv+1)/2,square);
            hm2 = ordfilt2(inImg(:,:,index),sv,cross);
            hm3 = ordfilt2(inImg(:,:,index),sv,diag);
            temp = sort(cat(3,hm1,hm2,hm3),3);
            hm(:,:,index) = temp(:,:,2);
        end

    end

%     % Hybrid median filter
%     function hm = hybridMedfilt(inImg)
%         
%         [h,w,c] = size(inImg);
%         if (c==3)
%             hm = mat2cell(inImg,h,w,[1 1 1]);
%         else
%             hm = mat2cell(inImg,h,w,1);
%         end
% 
%         % Filtering
%         hm1 = cellfun(@(x)ordfilt2(x,(sv*sv+1)/2,square),hm,'UniformOutput',false);
%         hm2 = cellfun(@(x)ordfilt2(x,sv,cross),hm,'UniformOutput',false);
%         hm3 = cellfun(@(x)ordfilt2(x,sv,diag),hm,'UniformOutput',false);
%         hm = cellfun(@(x,y,z)median(cat(3,x,y,z),3),hm1,hm2,hm3,'UniformOutput',false);
%         hm = cell2mat(hm);
%         
%     end
end
