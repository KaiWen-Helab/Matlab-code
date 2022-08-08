clear
a=dir(fullfile('*.xlsx'));        %����Ŀ¼���ļ���Ϣ�洢Ϊ�ṹ����ʽ
b=struct2cell(a);  %����ʽתΪcell��ʽ
c=b(1,:);        %ȡ�������ļ�����
[h,l]=size(c);   %�����ļ�����
jj=0;             %xls�ļ���
for ii=1:1:l           
    if strfind(c{ii},'.xlsx')    %�����xls�ļ���ʽ ע������Ҫʹ��cell������
        jj=jj+1;
        [xlsstr{jj}]=xlsread(c{ii}); 
    end
end
for q=1:1:l;
A=xlsstr{1,q};
RMSdata=A(:,10);
RMSdata=RMSdata(~isnan(RMSdata));
RMSBSL=mode(RMSdata);
RMSAmp=RMSdata-RMSBSL;
RMSsquare=arrayfun(@(x)x*x,RMSAmp);
RMS{1,q}=sqrt(mean(RMSsquare));
K=1;
for i=2:2:8
A1=A(:,i);
A2=A1(~isnan(A1));
[m2,n2]=size(A2);
cnt=1;
for j=1:5000:5000*fix(m2/5000);
A3=A2(j:j+4999,:);
meanBSL=mean(mode(A3));
A4=bsxfun(@minus,A3,meanBSL.');
M=sum(A4);
fivemillisecondcharge{i/2,cnt,q}=M;
cnt=cnt+1;
end
end
FragmentMatrix=cellfun(@sum,fivemillisecondcharge);
FragmentI=FragmentMatrix(1:4,:,q);
NumI=length(nonzeros(FragmentMatrix(1:4,:,q)));
CellI{q}=sum(FragmentI(:))/NumI*2;
end
AllI=cell2mat(CellI);
Filename=b(1,:);
Items={'Filename','RMS','I',}';
AllI=num2cell(AllI);
FinalData=[Filename;RMS;AllI];
Result=[Items,FinalData];
xlswrite('Result.xlsx',Result);



