//
//  DZStoredObjects.m
//  DangerZone
//
//  Created by Christopher Morse on 10/28/12.
//  Copyright (c) 2012 Morse-Code. All rights reserved.
//
#import "DZStoredObjects.h"


#pragma mark -
#pragma mark Private Class handles undo and UIDocument auto save

@interface UndoInfo : NSObject


@property (strong, nonatomic) NSMutableArray *dangerZones;
@end

@implementation UndoInfo


@synthesize dangerZones = _dangerZones;
@end

@interface DZStoredObjects ()


@property (nonatomic, strong) NSMutableArray *dangerZoneObjects;

+ (NSURL *)localURL;

- (void)undoUpdateWithArray:(UndoInfo *)info;
@end

#pragma mark -
#pragma mark DZStoredObjects implementation

static NSString *const FileName = @"dangerZone.dzstate";


@implementation DZStoredObjects


@synthesize dangerZoneObjects = _dangerZoneObjects;


+ (NSURL *)localURL
{
    static NSURL *sharedLocalURL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
{
    NSError *error;
    NSURL *documentDirectory = [[NSFileManager defaultManager]
                                               URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask
                                             appropriateForURL:nil create:NO error:&error];
    if (documentDirectory == nil) {
        [NSException raise:NSInternalInconsistencyException format:@"Unable to locate the local document "
                                                                           @"directory, %@",
                                                                   [error localizedDescription]];
    }
    sharedLocalURL = [documentDirectory URLByAppendingPathComponent:FileName];
});
    return sharedLocalURL;
}


- (void)undoUpdateWithArray:(UndoInfo *)info
{
    self.dangerZoneObjects = info.dangerZones;
}


+ (void)accessDangerZoneObject:(dangerZoneAccessHandler)accessHandler
{
    NSURL *url;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    url = [self localURL];
    DZStoredObjects *saved = [[self alloc] initWithFileURL:url];
    if ([fileManager fileExistsAtPath:[url path]]) {
        [saved openWithCompletionHandler:^(BOOL success)
        {
            accessHandler(success, saved);
        }];
    }
    else
    {
        [saved saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success)
        {
            accessHandler(success, saved);
        }];
    }
}


- (id)initWithFileURL:(NSURL *)url
{
    self = [super initWithFileURL:url];
    if (self) {
        _dangerZoneObjects = [[NSMutableArray alloc] init];
    }

    return self;
}

#pragma mark -
#pragma mark UIDocument methods
- (id)contentsForType:(NSString *)typeName
                error:(NSError **)outError
{
    return [NSKeyedArchiver archivedDataWithRootObject:self.dangerZoneObjects];
}


- (BOOL)loadFromContents:(id)contents
                  ofType:(NSString *)typeName
                   error:(NSError **)outError
{
    self.dangerZoneObjects = [NSKeyedUnarchiver unarchiveObjectWithData:contents];

    // Clear the undo stack.
    //[self.undoManager removeAllActions];
    return YES;
}


+ (NSSet *)keyPathsForValuesAffectingDangerZones
{
    return [NSSet setWithObjects:@"dangerZoneObjects", nil];
}


- (NSArray *)zones
{
    return self.dangerZoneObjects;
}


- (void)updateWithArray:(NSArray *)array
{
    NSMutableArray *dangerZones = self.dangerZoneObjects;
    self.dangerZoneObjects = (NSMutableArray *)array;
    UndoInfo *info = [[UndoInfo alloc] init];
    info.dangerZones = dangerZones;
    [self.undoManager registerUndoWithTarget:self selector:@selector(undoUpdateWithArray:) object:info];
    NSString *name = [NSString stringWithFormat:@"Revert the last update?"];
    [self.undoManager setActionName:name];

}


@end
