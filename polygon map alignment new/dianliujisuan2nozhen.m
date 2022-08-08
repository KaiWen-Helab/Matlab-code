%程序将标准图像映射到原图空间中，得到标准图像方框每个像素点对应的像素点，从而得到这一个像素点对应的电流值。
%
%所有图像中网格划分的方式为根据针尖点检测的位置，上下左右推12个像素点得到第116个区域的坐标，从而推出所有网格坐标。
%算法实现的方式为：
%1.读入针点位置信息。
%2.读入标准图像转换为测试图像的数据
%3.读入测量图像的网格电流值
%4.标准图像从[1,1]开始，计算每个像素点映射到某个测试图像后的坐标值。
%5.计算映射后的点距离测试图像针点的距离，通过距离判定该点位于测试图像的网格位置。
%6.如果该点位于某个网格中，则该点电流值加上网格电流值/(24*24),并记录该点有电流的个数
%7.所有测试图像映射完后，该点的电流值为电流值的和/有电流个数
%8.将标准图像每点电流平均值数据存储在diandata.mat中。
%该程序与dianliujisuan2zhzen的区别是，标准图像映射到测试图像（右上角关键点相同，两点连线重合）后，不进行针尖点平移，
%映射后的标准图像点直接计算与测试图像针尖点距离，从而计算网格电流值。
%created by zhangyan 2019/9/10

clear
imname='E:\中科院\宗方娇\polygon alignment to ZY_080219\9-2\standardzhen.txt';
[xbm,ybm]=textread(imname);%读出针点位置
% xstart=floor(xbm-(7*24+12));%根据针点位置，计算网格四周坐标
% xend=floor(xbm+(7*24+12));
% ystart=floor(ybm-(10*24+12));
% yend=floor(ybm+(4*24+12));

tr_dir1='E:\中科院\宗方娇\polygon alignment to ZY_080219\9-2\zt0\新校正数据\';
jpgstr = dir([tr_dir1 '\*.txt']);
filenames={jpgstr.name};
[fm,fn]=size(filenames);
tr_dir2='E:\中科院\宗方娇\polygon alignment to ZY_080219\9-2\zt0\针点数据\';
diandata=zeros(369,680);%标准图像电流值每个像素点初始设置
i=0;
j=0;
dianrawdata=zeros(15,15,fn);%标准图像区域电流值数据
tr_dir3='E:\中科院\宗方娇\polygon alignment to ZY_080219\9-2\zt0\zt0_excel\';
for i=1:fn         %读入每次测量的区域数据
    strname=filenames{i};
    dianname=strcat(tr_dir3,strname(1:end-4));
    dianname=strcat(dianname,'.csv');
    [num,txt,raw]=xlsread(dianname);
    dianrawdata(:,:,i)=num;
end
hi=0;
hj=0;
for ii=1:369%选中像素点的x坐标
    hi=hi+1;
    hj=0;
    for jj=1:680%选中像素点的y坐标
        hj=hj+1;
        diannum=0;
        for kk=1:fn     %选中一幅测量图像
            reconame=strcat(tr_dir1,filenames{kk});
            zhendata=strcat(tr_dir2,filenames{kk});
            [xcha,ycha,xbm1,ybm1,angle,xba1,yba1]=textread(reconame);%读入标准图像与该测量图像配准的参数（平移大小，旋转点，旋转角度，测量图像右下角关键点坐标）。
            realangle=angle*pi/180;
            [xzhen,yzhen]=textread(zhendata);%读入测量图像针点位置
            iin=ii+xcha;%将当前像素点按测量图像右上关键点平移
            jjn=jj+ycha;
            iinn=(iin-xbm1)*cos(realangle)-(jjn-ybm1)*sin(realangle)+xbm1;%当前像素点绕旋转点点旋转角度
            jjnn=(iin-xbm1)*sin(realangle)+(jjn-ybm1)*cos(realangle)+ybm1;
            xdis=iinn-(xzhen-12);%计算该点到针尖点位置，用于判定其位于哪个网格中
            ydis=jjnn-(yzhen-12);
            xpos=xdis/24;%计算网格数
            ypos=ydis/24;
            xindex=floor(8+xpos); %中心点的网格为（8,11）
            yindex=floor(11+ypos);
            if xindex>0 && xindex<16 && yindex>0 && yindex<16  %如果在有数据的网格中，则增加其电流值为当前网格电流值的1/(24*24)
                diandata(hi,hj)=diandata(hi,hj)+dianrawdata(xindex,yindex,kk)/(24*24);%hi,hj为标准图像当前点电流值
                diannum=diannum+1;%当前点有电流数加1
            end
        end
        if diannum~=0
            diandata(hi,hj)=diandata(hi,hj)/diannum; %如果当前像素点有电流，则电流值等于和值除以有电流个数
        end
    end
end

save('E:\中科院\宗方娇\polygon alignment to ZY_080219\9-2\zt0\dianliunozhen结果\diandata.mat','diandata');%记录电流值数据
maxd=max(max(diandata));%对电流图像进行规范化，显示电流图像
mind=min(min(diandata));
diandataim=(diandata-mind)/(maxd-mind)*255;
figure,
imshow(uint8(diandataim));