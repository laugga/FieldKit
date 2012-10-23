//
//  UIColorTokenFieldCell.h
//  FieldKitOverview
//
//  Created by luis on 10/22/12.
//  Copyright (c) 2012 Luis Laugga. All rights reserved.
//

#import "LATokenFieldCell.h"

@interface UIColorTokenFieldCell : LATokenFieldCell
{
    UIColor * _lighterColor;
    UIColor * _darkerColor;
}
@property(nonatomic, retain) UIColor * lighterColor;
@property(nonatomic, retain) UIColor * darkerColor;

@end
