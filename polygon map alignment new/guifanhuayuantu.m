%����˵��������ԭͼ�淶��Ϊ���׼ͼ��ͬ����С��ͼ��[369,680],Ȼ���䱣�����淶��ԭͼ�ļ��С�
%created by zhangyan 2019-8-10;

clear
%tr_dir='E:\�п�Ժ\�ڷ���\polygon alignment to ZY_080219\zt0\ԭͼ';
tr_dir='E:\�п�Ժ\�ڷ���\polygon alignment to ZY_080219\zt12\ԭͼ';
jpgstr = dir([tr_dir '\*.jpg']);
filenames={jpgstr.name};
[fm,fn]=size(filenames);
for i=1:fn
    imname1=strcat(tr_dir,'\',filenames{i});    
    im1=imread(imname1);
    imnn=imresize(im1, [369,680],'nearest');
    %newdir='E:\�п�Ժ\�ڷ���\polygon alignment to ZY_080219\zt0\��ע�淶����\';
    newdir='E:\�п�Ժ\�ڷ���\polygon alignment to ZY_080219\zt12\�淶��ԭͼ\';

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
