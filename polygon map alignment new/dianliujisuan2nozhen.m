%���򽫱�׼ͼ��ӳ�䵽ԭͼ�ռ��У��õ���׼ͼ�񷽿�ÿ�����ص��Ӧ�����ص㣬�Ӷ��õ���һ�����ص��Ӧ�ĵ���ֵ��
%
%����ͼ�������񻮷ֵķ�ʽΪ�����������λ�ã�����������12�����ص�õ���116����������꣬�Ӷ��Ƴ������������ꡣ
%�㷨ʵ�ֵķ�ʽΪ��
%1.�������λ����Ϣ��
%2.�����׼ͼ��ת��Ϊ����ͼ�������
%3.�������ͼ����������ֵ
%4.��׼ͼ���[1,1]��ʼ������ÿ�����ص�ӳ�䵽ĳ������ͼ��������ֵ��
%5.����ӳ���ĵ�������ͼ�����ľ��룬ͨ�������ж��õ�λ�ڲ���ͼ�������λ�á�
%6.����õ�λ��ĳ�������У���õ����ֵ�����������ֵ/(24*24),����¼�õ��е����ĸ���
%7.���в���ͼ��ӳ����󣬸õ�ĵ���ֵΪ����ֵ�ĺ�/�е�������
%8.����׼ͼ��ÿ�����ƽ��ֵ���ݴ洢��diandata.mat�С�
%�ó�����dianliujisuan2zhzen�������ǣ���׼ͼ��ӳ�䵽����ͼ�����Ͻǹؼ�����ͬ�����������غϣ��󣬲���������ƽ�ƣ�
%ӳ���ı�׼ͼ���ֱ�Ӽ��������ͼ��������룬�Ӷ������������ֵ��
%created by zhangyan 2019/9/10

clear
imname='E:\�п�Ժ\�ڷ���\polygon alignment to ZY_080219\9-2\standardzhen.txt';
[xbm,ybm]=textread(imname);%�������λ��
% xstart=floor(xbm-(7*24+12));%�������λ�ã�����������������
% xend=floor(xbm+(7*24+12));
% ystart=floor(ybm-(10*24+12));
% yend=floor(ybm+(4*24+12));

tr_dir1='E:\�п�Ժ\�ڷ���\polygon alignment to ZY_080219\9-2\zt0\��У������\';
jpgstr = dir([tr_dir1 '\*.txt']);
filenames={jpgstr.name};
[fm,fn]=size(filenames);
tr_dir2='E:\�п�Ժ\�ڷ���\polygon alignment to ZY_080219\9-2\zt0\�������\';
diandata=zeros(369,680);%��׼ͼ�����ֵÿ�����ص��ʼ����
i=0;
j=0;
dianrawdata=zeros(15,15,fn);%��׼ͼ���������ֵ����
tr_dir3='E:\�п�Ժ\�ڷ���\polygon alignment to ZY_080219\9-2\zt0\zt0_excel\';
for i=1:fn         %����ÿ�β�������������
    strname=filenames{i};
    dianname=strcat(tr_dir3,strname(1:end-4));
    dianname=strcat(dianname,'.csv');
    [num,txt,raw]=xlsread(dianname);
    dianrawdata(:,:,i)=num;
end
hi=0;
hj=0;
for ii=1:369%ѡ�����ص��x����
    hi=hi+1;
    hj=0;
    for jj=1:680%ѡ�����ص��y����
        hj=hj+1;
        diannum=0;
        for kk=1:fn     %ѡ��һ������ͼ��
            reconame=strcat(tr_dir1,filenames{kk});
            zhendata=strcat(tr_dir2,filenames{kk});
            [xcha,ycha,xbm1,ybm1,angle,xba1,yba1]=textread(reconame);%�����׼ͼ����ò���ͼ����׼�Ĳ�����ƽ�ƴ�С����ת�㣬��ת�Ƕȣ�����ͼ�����½ǹؼ������꣩��
            realangle=angle*pi/180;
            [xzhen,yzhen]=textread(zhendata);%�������ͼ�����λ��
            iin=ii+xcha;%����ǰ���ص㰴����ͼ�����Ϲؼ���ƽ��
            jjn=jj+ycha;
            iinn=(iin-xbm1)*cos(realangle)-(jjn-ybm1)*sin(realangle)+xbm1;%��ǰ���ص�����ת�����ת�Ƕ�
            jjnn=(iin-xbm1)*sin(realangle)+(jjn-ybm1)*cos(realangle)+ybm1;
            xdis=iinn-(xzhen-12);%����õ㵽����λ�ã������ж���λ���ĸ�������
            ydis=jjnn-(yzhen-12);
            xpos=xdis/24;%����������
            ypos=ydis/24;
            xindex=floor(8+xpos); %���ĵ������Ϊ��8,11��
            yindex=floor(11+ypos);
            if xindex>0 && xindex<16 && yindex>0 && yindex<16  %����������ݵ������У������������ֵΪ��ǰ�������ֵ��1/(24*24)
                diandata(hi,hj)=diandata(hi,hj)+dianrawdata(xindex,yindex,kk)/(24*24);%hi,hjΪ��׼ͼ��ǰ�����ֵ
                diannum=diannum+1;%��ǰ���е�������1
            end
        end
        if diannum~=0
            diandata(hi,hj)=diandata(hi,hj)/diannum; %�����ǰ���ص��е����������ֵ���ں�ֵ�����е�������
        end
    end
end

save('E:\�п�Ժ\�ڷ���\polygon alignment to ZY_080219\9-2\zt0\dianliunozhen���\diandata.mat','diandata');%��¼����ֵ����
maxd=max(max(diandata));%�Ե���ͼ����й淶������ʾ����ͼ��
mind=min(min(diandata));
diandataim=(diandata-mind)/(maxd-mind)*255;
figure,
imshow(uint8(diandataim));