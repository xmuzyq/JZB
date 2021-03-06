//
//  CatalogListDataSource.m
//  JZB
//
//  Created by Jin Jin on 11-4-21.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "CatalogListDataSource.h"
#import "JJObjectManager.h"

@implementation CatalogListDataSource

@synthesize tempCell = _tempCell;
@synthesize catalogKind = _catalogKind;

-(void)setManagedObj:(JZBManagedObject *)managedObj{
    if (_managedObj != managedObj){
        [_managedObj release];
        _managedObj = managedObj;
        [_managedObj retain];
        
        self.catalogKind = [_managedObj valueForKey:@"kind"];
        
    }
}

-(void)setCatalogKind:(NSString*)catalogKind{
    if (_catalogKind != catalogKind){
        [_catalogKind release];
        _catalogKind = catalogKind;
        [_catalogKind retain];
        
        if (_catalogKind){
            self.predicate = [NSPredicate predicateWithFormat:@"%K like %@", @"kind", _catalogKind];
        }else{
            self.predicate = nil;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    NSInteger number = [[self.fetchedController sections] count];
    number = (!number)?1:number;
    DebugLog(@"number of section is %d", number);
    return number;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedController sections] objectAtIndex:section];
    NSInteger number = [sectionInfo numberOfObjects];
    number = (![[self.fetchedController fetchedObjects] count])?1:number;
    DebugLog(@"number of rows in section %d is %d", section, number);
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CatalogListCell";
    CatalogListCell* cell = (CatalogListCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell){
        [[NSBundle mainBundle] loadNibNamed:@"CatalogListCell" owner:self options:nil];
        cell = self.tempCell;
        self.tempCell = nil;
    }
    
    //if we have account, rather then zero
    if ([[self.fetchedController fetchedObjects] count]){
        NSManagedObject* obj = [self.fetchedController objectAtIndexPath:indexPath];
        // Configure the cell...
        cell.catalog = (JZBCatalogs*)obj; 
        //if the obj is the selected one, check mark the cell
        if ([self.managedObj isEqualToManagedObject:cell.catalog]){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }else{
        //no catalog in DB
        cell.textLabel.text = @"no catalog";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

-(id)init{
    self = [super init];
    if (self){
        self.modelName = @"JZBCatalogs";
    }
    
    return self;
}

-(void)dealloc{
    self.tempCell = nil;
    self.catalogKind = nil;
    [super dealloc];
}

@end
