//
//  CatalogEditViewController.m
//  JZB
//
//  Created by Jin Jin on 11-4-27.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "CatalogEditViewController.h"
#import "JZBCatalogs.h"

@implementation CatalogEditViewController

@synthesize nameCell = _nameCell;
@synthesize kindCell = _kindCell;
@synthesize nameTitle = _nameTitle;
@synthesize kindTitle = _kindTitle;
@synthesize nameText = _nameText;
@synthesize catalogKind = _catalogKind;
@synthesize kindLabel = _kindLabel;
@synthesize kindButton = _kindButton;
@synthesize catalog = _catalog;

-(void)saveJZBObj{
    [super saveJZBObj];
    //save the catalog to the DB
    JZBCatalogs* catalog = [JZBCatalogs insertNewManagedObject];
    [catalog setupDefaultValues];
    catalog.name = self.nameText.text;
    catalog.kind = self.catalogKind;
    [catalog persistantChange];
}

-(NSString*)getNotificationName{
    return NOTIFICATION_NEW_CATALOG_CREATED;
}

-(NSArray*)getCellArray{
    if (!_cellArray){
        NSArray* section1 = [NSArray arrayWithObjects:self.nameCell, self.kindCell, nil];
        _cellArray = [NSArray arrayWithObjects:section1, nil];
        [_cellArray retain];
    }
    
    return _cellArray;
}

-(NSArray*)getPickerItemsArray{
    if (!_pickerItemsArray){
        NSArray* section1 = [NSArray arrayWithObjects:CATALOG_KIND_INCOME, CATALOG_KIND_EXPEND, nil];
        _pickerItemsArray = [NSArray arrayWithObjects:section1, nil];
        [_pickerItemsArray retain];
    }
    
    return _pickerItemsArray;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    //do nothing here
    self.catalogKind = [self itemForPickerInComponent:component row:row];
}

-(void)releaseOutlet{
    self.nameText = nil;
    self.nameCell = nil;
    self.nameTitle = nil;
    self.kindCell = nil;
    self.kindTitle = nil;
    self.kindLabel = nil;
    self.kindButton = nil;
}

-(void)localizeViews{
    JZBLoalizeString(self.nameTitle.text, nil);
    JZBLoalizeString(self.kindTitle.text, nil);
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self localizeViews];
}

- (void)dealloc
{
    [self releaseOutlet];
    self.catalogKind = nil;
    self.catalog = nil;
    [super dealloc];
}

-(void)assemblyResponderArray{
    self.responderArray = [NSArray arrayWithObjects:self.nameText, nil];
}

-(void)setCatalogKind:(NSString*)catalogKind{
    if (_catalogKind != catalogKind){
        [_catalogKind release];
        _catalogKind = catalogKind;
        [_catalogKind retain];
        self.kindLabel.text = NSLocalizedString(_catalogKind, nil);
    }
}

-(BOOL)validateInput{
    BOOL valid = YES;
    NSString* reason = nil;
    //if name is full of space characters or nil
    if (![[self.nameText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]){
        valid = NO;
        reason = @"name could not be empty";
    }else if ([[self.nameText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 10){//if name is too long
        valid = NO;
        reason = @"length of name is too long";
    }
    
    if (!valid){
        //pop up alter view
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                        message:reason
                                                       delegate:nil
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    return valid;
    
}

-(void)setupInitialValuesForViews{
    if (self.catalog){
        self.title = NSLocalizedString(@"title_edit_catalog", nil);
        self.nameText.text = self.catalog.name;
        self.catalogKind = self.catalog.kind;
    }else{
        self.title = NSLocalizedString(@"title_new_catalog", nil);
        //if catalog kind is nil
        if (!self.catalogKind){
            self.catalogKind = CATALOG_KIND_EXPEND;   
        }
    }
}

@end
