# ZJTagView
一个collectionView拖动的实现demo, 已经实现网易新闻的标签编辑效果. 标签页面, 频道选择



![tagView.gif](http://upload-images.jianshu.io/upload_images/1271831-15723b070812c6ae.gif?imageMogr2/auto-orient/strip)


```
    // 初始化第一个section数据
    for (int i=0; i<20; i++) {
        ZJTagItem *item = [ZJTagItem new];
        item.name = [NSString stringWithFormat:@"选中--- %d",i];
        [selectedItems addObject:item];
    }
    // 初始化第二个section数据
    for (int i=0; i<40; i++) {
        ZJTagItem *item = [ZJTagItem new];
        item.name = [NSString stringWithFormat:@"未选中--- %d",i];
        [unselectedItems addObject:item];
    }
    // 初始化
    _tagView = [[ZJTagView alloc] initWithSelectedItems:selectedItems unselectedItems:unselectedItems];
```

> 这是我写的<iOS自定义控件剖析>这本书籍中的一个demo, 如果你希望知道具体的实现过程和其他的一些常用效果的实现, 那么你应该能轻易在网上下载到免费的盗版书籍. 

> 当然作为本书的写作者, 还是希望有人能支持正版书籍. 如果你有意购买书籍, 在[这篇文章中](http://www.jianshu.com/p/510500f3aebd), 介绍了书籍中所有的内容和书籍适合阅读的人群, 和一些试读章节, 以及购买链接. 在你准备[购买](http://www.qingdan.us/product/13)之前, 请一定读一读里面的说明. 否则, 如果不适合你阅读, 虽然书籍售价35不是很贵, 但是也是一笔损失.


> 如果你希望联系到我, 可以通过[简书](http://www.jianshu.com/users/fb31a3d1ec30/latest_articles)联系到我
