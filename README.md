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