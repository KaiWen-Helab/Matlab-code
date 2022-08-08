%Batch extract dFF/ave rawF/ave F0/R2 between dFF&rawF from GCamP6s_based 2
%photon Ca images
%datafile: excel containing raw fluorescence signal extracted from all
%neurons in a view. Each row is one cell, all cells have same frames.
%Exported data: Sdec: deconvolved neural activity of all neurons in a view;
%FR: calculated firing rate of all neurons in a view
%Created by HKW on 5/8/2020,modified by HKW on 1/31/21

clc;clearvars;
clear all
cd 'D:\Kaiwen\HeLab\HeLab data\Students\Zong FJ\2p sCa\2021 all\dFF&fig-012721\pyr sCa\exc\excFOVs-ZT12\';

excel_fn = dir('*.xlsx');
filenames = {excel_fn.name};
n_excel = length(filenames)
jj=0
skipCell=[]
Fave=[]
F0ave=[]
r=[]
R=[]
rmsCell=[]
rmsCellLoc=[] 
sumCell=[];

for a=1:n_excel

    if strfind(filenames{a},'.xlsx')    %如果是xls文件格式 注意括号要使用cell的括号
        cellContents = filenames{a};
        dataname{a} = cellContents(1:end-5)
        
        jj=jj+1;
        rawF{jj}=xlsread(filenames{a});
        [m,n] = size(rawF{1,a});
        for b =1:m
            rawF_LPF{jj}(b,:)=lowpass(rawF{jj}(b,:),[0.5],10); %lowpass filter rawF with 0.5Hz cutoff
            %rawF_LPF{jj}(a,:)=bandpass(rawF{jj}(a,:),[0.01 4],10);  %bandpass filter signal between 0.05 and 5 Hz with a sampling rate at 10hz
        end
        
        FR=[];
        C_dec=[];       % deconvolved DF/F trace
        S_dec=[];       % deconvolved neural activity
        yy = [];
        length=0
        APrate=0

        
        for i = 1:m
            Fo = rawF{1,a}(i,:);
            Fo = Fo(~isnan(Fo));
            Fo = Fo(201:end); 
            F = rawF_LPF{1,a}(i,:);
            F = F(~isnan(F));
            F = F(201:end);            %exclude the initial 25s imaging artifact
            Fave(a,i) = mean(F,2);           
            
            length(i) = numel(F);
%             figure;
%             plot(Fo);
%             hold all;
%             plot(F);   %plot raw F in figure      
%             
            Frag = []
            mFrag = 0
            qtFrag = 0
            minFrag = 0
            iniF = 0
            endF = 0
            dFF_Frag = []
            y = []
            
            sumF0=0
            fragCount=7
            %% dFF calculation
            
            for xx =1:fragCount
                iniF = 1+(xx-1)*length(i)/fragCount;
                endF = xx*length(i)/fragCount;
                Frag = F(iniF:endF);                 %divide the whole fluorescence into 10 fragments.
                mFrag = mean(Frag);
                qtFrag = quantile(Frag,0.3)        %find 30% quantile of the fragment fluorescence (1/5 of all frames, 600s) for the cumulative probability or probabilities p in the interval [0,1].
                sumF0 = sumF0+qtFrag
                minFrag = min(Frag);                  %find the minimum value of the fragment, suitable for PV Ca images analysis
                dFF_Frag = (Frag-qtFrag)/qtFrag;    %extract dF/F for each fragments
                y = [y,dFF_Frag]
            end
            %% 
            F0ave(a,i) = sumF0/7;
%             plot(gca,y*100,'m');   %plot dff*100 in the same figure as rawF
%             dFF_figName = strcat(string(dataname{1,a}),'-',string(i),'.jpeg')
%             saveas(gca,dFF_figName);   %save plot.
%             close all;

            yy(i,:) = y(:)*100;
                        
            r=[corrcoef(F,y)];      %calculate R2 between rawF and dFF
            R(a,i)=r(2);             
            
            rmsFrag=50      %use 50 datapoint (5s) to estimate rms        
            rmsSec=0
            minRms = 100
            minRmsLoc=0
            for c=1:(length(i)-rmsFrag+1)       %find the min RMS of each cell
                sec=c+rmsFrag-1
                rmsSec=rms(y(c:sec))
                if minRms>rmsSec
                    minRms=rmsSec
                    minRmsLoc=c
                else
                    minRms=minRms
                    minRmsLoc=minRmsLoc
                end
            end  
        rmsCell{1,a}{i,1}=minRms;
        rmsCellLoc{1,a}{i,1}=minRmsLoc; 
        
        y_deRms=y;
        y_deRms(find(y_deRms<3*minRms))=0;
        y_sum=sum(y_deRms);
        sumCell{1,a}{i,1}=y_sum;
        end        
        
        dFF{1,a}=yy;
        name_yy = strcat(string(dataname{1,a}),'_dFF','.xlsx')      %define exported excel name
        xlswrite(name_yy,yy);                %write dF/F into sheet1 of exported excel       
        xlswrite(name_yy,rmsCellLoc{1,a},'Sheet2','A2');
        xlswrite(name_yy,rmsCell{1,a},'Sheet2','B2')
        xlswrite(name_yy,sumCell{1,a},'Sheet2','D2')
    end
end

%% scatter plot of deRMS sum dFF of each cell pair 
vector1=cell2mat(sumCell{1,1});
vector2=cell2mat(sumCell{1,2});
cellList=1:m
cellList=reshape(cellList,[m,1])
ratio=vector2./vector1
compile=[ratio,vector1,vector2,cellList]
annotation(figure,'line',[0.130769230769231 0.904395604395604],[0.110261872455902 0.924016282225237],'LineWidth',1,'LineStyle','--');
hold on;
scatter(compile(:,2),compile(:,3),10,'R','filled');
set(gcf,'Position',[2000 400 560 535]);
originalSize1 = get(gca, 'Position');
xlabel(string(dataname{1,1}));
ylabel(string(dataname{1,2}));
% xlabel({'ZT0-sum(dF/F0)'});
% ylabel({'ZT12-sum(dF/F0)'});
maxAxis=max(xlim,ylim);
set(gca,'XLim',[0 maxAxis(2)]); 
set(gca,'YLim',[0 maxAxis(2)]);
%set(gca,'YLim',[0 d(2)]);   
set(gca, 'Position', originalSize1);
splotName= strcat(dataname{1,1},'-scatter.jpeg')
saveas(gca,splotName);
close all;
%c_sort=sortrows(compile);
%ratio=reshape(ratio,[1,m]);
%% 

%% exclude cells based on R2 between rawF and dFF for independent dataset
sR2=0.7
skipCount=[];
for a=1:n_excel
    [m,n]=size(dFF{1,a});
    skip=0
    for i=1:m
        if R(a,i)<sR2
           dFF_exc{1,a}(i,:)= dFF{1,a}(i,:)*0
           skip=skip+1
        else
           dFF_exc{1,a}(i,:)=dFF{1,a}(i,:)
           skip=skip;
        end
    end
    skipCount=[skipCount,skip]
end



% % exclude cells based on R2 between rawF and dFF for paired datasets(zt0
% %vs zt12)
% sR2=0.7
% skip=0;
% sumCell1=cell2mat(sumCell{1,1});
% sumCell2=cell2mat(sumCell{1,2});
% Ratio=sumCell2./sumCell1;
% Ratio=reshape(Ratio,[1,m]);
% for i=1:m
%     if R(1,i)<sR2             %adjust R criterior to match dataset specificity
%         dFF_exc{1,1}(i,:)=dFF{1,1}(i,:)*0
%         dFF_exc{1,2}(i,:)=dFF{1,2}(i,:)*0
%         sumCell_exc1(i)=sumCell1(i)*0
%         sumCell_exc2(i)=sumCell2(i)*0
%         skip=skip+1;
%         skipCell(skip)=i;
%     else if R(2,i)<sR2
%             dFF_exc{1,1}(i,:)=dFF{1,1}(i,:)*0
%             dFF_exc{1,2}(i,:)=dFF{1,2}(i,:)*0
%             sumCell_exc1(i)=sumCell1(i)*0
%             sumCell_exc2(i)=sumCell2(i)*0
%             skip=skip+1;
%             skipCell(skip)=i;
%         else if R(1,i)<sR2 & R(2,i)<sR2
%                 dFF_exc{1,1}(i,:)=dFF{1,1}(i,:)*0
%                 dFF_exc{1,2}(i,:)=dFF{1,2}(i,:)*0
%                 sumCell_exc1(i)=sumCell1(i)*0
%                 sumCell_exc2(i)=sumCell2(i)*0
%                 skip=skip+1;
%                 skipCell(skip)=i;
%             else
%                 dFF_exc{1,1}(i,:)=dFF{1,1}(i,:)
%                 dFF_exc{1,2}(i,:)=dFF{1,2}(i,:)
%                 sumCell_exc1(i)=sumCell1(i)
%                 sumCell_exc2(i)=sumCell2(i)
%                 skip=skip;
%             end
%         end
%     end
% end

% sumCell_exc=[sumCell_exc1;sumCell_exc2;Ratio];
% sumCell_exc=sumCell_exc';
% sum_sort=sortrows(sumCell_exc,1,'descend');
% 
% %sumCell_exc=reshape(sumCell_exc,[m,3]);
% xlswrite('sumCell_exc.xlsx',sum_sort);
% 


%% write excluded dFF into excel with filename-exc_dFF
dFFexc=[]
for a=1:n_excel
    if strfind(filenames{a},'.xlsx')   
        cellContents = filenames{a};
        dataname{a} = cellContents(1:end-5)
        %name_dFF_exc = strcat(string(dataname{1,a}),'-exc_dFF','.xlsx')      %define exported excel name of compiled data from all views from the same group
        name_dFF_exc =strcat(string(dataname{1,a}),'-exc_dFF','-',num2str(skipCount(a)),'.xlsx')
        %define exported excel name for each view by adding "-exc_dFF"
        %followed by excluded cell number
        dFFexc = dFF_exc{1,a}
        
        dFFexc(all(dFFexc==0,2),:)=[]
        [c,d]=size(dFFexc)
        xlswrite(name_dFF_exc,dFFexc)                %write dF/F into sheet1 of exported excel
    end
end
% 
%% write excluded cell information, and meanF, mean F0, and R2 between dFF & rawF into csv.

CellList=1:m
space=NaN(1,m,'single');
compile=[CellList;Fave;space;F0ave;space;R;space;Ratio];
csvwrite('Fave.csv',compile,0,1);
skipcelllist=[skipCell,NaN,skip];
csvwrite('Fskip.csv',skipcelllist);

% xlswrite('Fave',CellList,'Sheet1','B1');
% xlswrite('Fave',Fave,'Sheet1','B2');
% xlswrite('Fave',F0ave,'Sheet1','B5');
% xlswrite('Fave',R,'Sheet1','B8');
% xlswrite('Fave',ratio,'Sheet1','B11');
% xlswrite('Fave',skipCell,'Sheet1','B13');
% xlswrite('Fave',skip,'Sheet1','B14');
       

