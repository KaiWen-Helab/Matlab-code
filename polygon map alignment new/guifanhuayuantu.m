%程序说明：程序将原图规范化为与标准图像同样大小的图像[369,680],然后将其保存至规范化原图文件夹。
%created by zhangyan 2019-8-10;

clear
%tr_dir='E:\中科院\宗方娇\polygon alignment to ZY_080219\zt0\原图';
tr_dir='E:\中科院\宗方娇\polygon alignment to ZY_080219\zt12\原图';
jpgstr = dir([tr_dir '\*.jpg']);
filenames={jpgstr.name};
[fm,fn]=size(filenames);
for i=1:fn
    imname1=strcat(tr_dir,'\',filenames{i});    
    im1=imread(imname1);
    imnn=imresize(im1, [369,680],'nearest');
    %newdir='E:\中科院\宗方娇\polygon alignment to ZY_080219\zt0\标注规范数据\';
    newdir='E:\中科院\宗方娇\polygon alignment to ZY_080219\zt12\规范化原图\';

    jiaozhengname=strcat(newdir,filenames{i});
    imwrite(uint8(imnn),jiaozhengname);
    
%     for ii=-5:5
%         for jj=-5:5
%             imnn(floor(xbm)+ii,floor(ybm)+jj,:)=0;
%         end
%     end
%     figure,
%     imshow(imnn);
 end
