//
//  ExportInfoManager.m
//  IpaExporter
//
//  Created by 何遵祖 on 2016/9/28.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import "ExportInfoManager.h"

#define INFOS_MAX_CAPACITY 100

#define SAVE_DETAIL_ARRARY_KEY @"detailArray"
#define SAVE_PROJECT_PATH_KEY @"projectPath"
#define SAVE_EXPORT_PATH_KEY @"exportPath"

@implementation ExportInfoManager

- (void)dealloc
{
    free(_info);
}

- (id)init
{
    if(self =[super init])
    {
        _info = (ExportInfo*)malloc(sizeof(ExportInfo)); 
        _info->exportFolderParh = "";
        _info->unityProjPath = "";
        
        _saveData = [NSUserDefaults standardUserDefaults];
        _detailArray = [[NSMutableArray alloc] initWithCapacity:20];
        _unityProjPathArr = [[NSMutableArray alloc] initWithCapacity:6];
        _exportPathArr = [[NSMutableArray alloc] initWithCapacity:6];
    }
    
    return self;
}

//主路径部分
- (void)reloadPaths
{
    NSData* unityProjData = (NSData*)[_saveData objectForKey:SAVE_PROJECT_PATH_KEY];
    NSArray* unityProjArray = [NSKeyedUnarchiver unarchiveObjectWithData:unityProjData];
    NSMutableArray* unityProjMutable = [NSMutableArray arrayWithArray:unityProjArray];
    _unityProjPathArr = unityProjMutable;
    
    NSData* exportData = (NSData*)[_saveData objectForKey:SAVE_EXPORT_PATH_KEY];
    NSArray* exportArray = [NSKeyedUnarchiver unarchiveObjectWithData:exportData];
    NSMutableArray* exportMutable = [NSMutableArray arrayWithArray:exportArray];
    _exportPathArr = exportMutable;
}

- (void)saveData
{
    NSData* unityArrData = [NSKeyedArchiver archivedDataWithRootObject:_unityProjPathArr];
    [_saveData setObject:unityArrData forKey:SAVE_PROJECT_PATH_KEY];
    NSData* exportArrData = [NSKeyedArchiver archivedDataWithRootObject:_exportPathArr];
    [_saveData setObject:exportArrData forKey:SAVE_EXPORT_PATH_KEY];
    
    [_saveData synchronize];
}

- (ExportInfo*)getData
{
    ExportInfo* val;
    NSValue* value = (NSValue*)[_saveData objectForKey:@"test"];
    [value getValue:&val];
    return val;
}

- (void)addNewUnityProjPath:(NSString *)path
{
    NSAssert(path != nil, @"路径不能为空");
    [_unityProjPathArr addObject:path];
    
    if([_unityProjPathArr count] > 5)
    {
        [_unityProjPathArr removeObjectAtIndex:0];
    }
}

- (void)replaceUnityProjPath:(NSString*)path
{
    NSUInteger index = [_unityProjPathArr indexOfObject:path];
    id lastObj = [_unityProjPathArr lastObject];
    [_unityProjPathArr replaceObjectAtIndex:[_unityProjPathArr count] - 1 withObject:path];
    [_unityProjPathArr replaceObjectAtIndex:index withObject:lastObj];
}

- (void)addNewExportProjPath:(NSString *)path
{
    NSAssert(path != nil, @"路径不能为空");
    [_exportPathArr addObject:path];
    
    if([_exportPathArr count] > 5)
    {
        [_exportPathArr removeLastObject];
    }
}

- (void)replaceExportProjPath:(NSString*)path
{
    NSUInteger index = [_exportPathArr indexOfObject:path];
    id fristObj = [_exportPathArr objectAtIndex:0];
    [_exportPathArr replaceObjectAtIndex:0 withObject:path];
    [_exportPathArr replaceObjectAtIndex:index withObject:fristObj];
}

//包配置 信息表格数据部分
- (void)saveDetail
{
    NSData* arrayData = [NSKeyedArchiver archivedDataWithRootObject:_detailArray];
    [_saveData setObject:arrayData forKey:SAVE_DETAIL_ARRARY_KEY];
    [_saveData synchronize];
}

- (NSMutableArray*)reLoadDetails
{
    NSData* arrayData = (NSData*)[_saveData objectForKey:SAVE_DETAIL_ARRARY_KEY];
    NSArray* array = [NSKeyedUnarchiver unarchiveObjectWithData:arrayData];
    NSMutableArray* mutable = [NSMutableArray arrayWithArray:array];
    _detailArray = mutable;
    return mutable;
}

- (void)addDetail:(DetailsInfoData*)data
{
    if (data == nil)
        return;
    
    [_detailArray addObject:data];
    [self saveDetail];
}

- (void)removeDetail:(NSUInteger)index
{
    [_detailArray removeObjectAtIndex:index];
    [self saveDetail];
}

- (void)updateDetail:(NSUInteger)index withObject:(id)object
{
    if (object == nil)
        return;
    
    [_detailArray replaceObjectAtIndex:index withObject:object];
    [self saveDetail];
}

@end
