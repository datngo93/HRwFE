%%=========================================================================
% Copyright © 2018, SoC Design Lab., Dong-A University. All Right Reserved.
%==========================================================================
% • Date       : 2018/04/05
% • Author     : Dat Ngo
% • Affiliation: SoC Design Lab. - Dong-A University
% • Design     : Hybrid median filter implementation (ver. 3)
%==========================================================================
function hm = hmfm_v33_rgb(input,sv)

% Boundary extension
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
hm = hmtemp((sv+1)/2:end-(sv-1)/2,(sv+1)/2:end-(sv-1)/2,:);

%     % Hybrid median filter
%     function hm = hybridMedfilt(inImg)
%         
%         [h,w,c] = size(inImg);
%         if ((h<2160)&&(w<4096))
%             hm = zeros(h,w,c);
%             for index = 1:c
%                 hm1 = ordfilt2(inImg(:,:,index),(sv*sv+1)/2,square);
%                 hm2 = ordfilt2(inImg(:,:,index),sv,cross);
%                 hm3 = ordfilt2(inImg(:,:,index),sv,diag);
%                 hm(:,:,index) = median(cat(3,hm1,hm2,hm3),3);
%             end
%         else
%             save('temp.mat','inImg','sv','square','cross','diag','-v7.3');
%             system(['matlab -batch "load temp; hm1 = ordfilt2(inImg(:,:,1),(sv*sv+1)/2,square);',...
%                 'hm2 = ordfilt2(inImg(:,:,1),sv,cross);',...
%                 'hm3 = ordfilt2(inImg(:,:,1),sv,diag);',...
%                 'hmr = median(cat(3,hm1,hm2,hm3),3);',...
%                 'save(',char(39),'hmr.mat',char(39),',',char(39),'hmr',char(39),',',char(39),'-v7.3',char(39),');" &']);
%             system(['matlab -batch "load temp; hm1 = ordfilt2(inImg(:,:,2),(sv*sv+1)/2,square);',...
%                 'hm2 = ordfilt2(inImg(:,:,2),sv,cross);',...
%                 'hm3 = ordfilt2(inImg(:,:,2),sv,diag);',...
%                 'hmg = median(cat(3,hm1,hm2,hm3),3);',...
%                 'save(',char(39),'hmg.mat',char(39),',',char(39),'hmg',char(39),',',char(39),'-v7.3',char(39),');" &']);
%             system(['matlab -batch "load temp; hm1 = ordfilt2(inImg(:,:,3),(sv*sv+1)/2,square);',...
%                 'hm2 = ordfilt2(inImg(:,:,3),sv,cross);',...
%                 'hm3 = ordfilt2(inImg(:,:,3),sv,diag);',...
%                 'hmb = median(cat(3,hm1,hm2,hm3),3);',...
%                 'save(',char(39),'hmb.mat',char(39),',',char(39),'hmb',char(39),',',char(39),'-v7.3',char(39),');" &']);
%             while ((~isfile('hmr.mat'))||(~isfile('hmg.mat'))||(~isfile('hmb.mat')))
%                 % wait
%             end
%             load hmr.mat hmr;
%             load hmg.mat hmg;
%             load hmb.mat hmb;
%             hm = cat(3,hmr,hmg,hmb);
%             delete temp.mat hmr.mat hmg.mat hmb.mat;
%         end
%     end

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
%         hm1 = zeros(h,w,c);
%         hm2 = zeros(h,w,c);
%         hm3 = zeros(h,w,c);
%         hm = zeros(h,w,c);
%        
%         % Filtering
%         parfor (i = 1:c, 12); hm1(:,:,i) = ordfilt2(inImg(:,:,i),(sv*sv+1)/2,square); ...
%                               hm2(:,:,i) = ordfilt2(inImg(:,:,i),sv,cross); ...
%                               hm3(:,:,i) = ordfilt2(inImg(:,:,i),sv,diag); ...
%         end
%         parfor (i = 1:c, 12); hm(:,:,i) = median(cat(3,hm1(:,:,i),hm2(:,:,i),hm3(:,:,i)),3); end
%     end
% 
%     % Hybrid median filter
%     function hm = hybridMedfilt(inImg)
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
%         % hm1 = startmulticoremaster(@myfun1,hm);
%         % hm2 = startmulticoremaster(@myfun2,hm);
%         % hm3 = startmulticoremaster(@myfun3,hm);
%         % hm = cellfun(@(x,y,z)median(cat(3,x,y,z),3),hm1,hm2,hm3,'UniformOutput',false);
%         % hm = cell2mat(hm);
%         %
%         % function out = myfun1(in)
%         %     out = ordfilt2(in,(sv*sv+1)/2,square);
%         % end
%         % function out = myfun2(in)
%         %     out = ordfilt2(in,sv,cross);
%         % end
%         % function out = myfun3(in)
%         %     out = ordfilt2(in,sv,diag);
%         % end
%     end
end
