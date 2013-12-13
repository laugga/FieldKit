/*
 
 FKTextInteractionAssistant.m
 FieldKit
 
 Copyright (cc) 2012 Luis Laugga.
 Some rights reserved, all wrongs deserved.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of
 this software and associated documentation files (the "Software"), to deal in
 the Software without restriction, including without limitation the rights to
 use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 the Software, and to permit persons to whom the Software is furnished to do so,
 subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
*/

#import "FKTextInteractionAssistant.h"
#import "FKTextInteractionAssistant_Internal.h"

#import "FKTextSelectionView.h"

@implementation FKTextInteractionAssistant

@synthesize selectingContainer = _selectingContainer;
@synthesize singleTapGesture = _singleTapGesture;
@synthesize doubleTapGesture = _doubleTapGesture;

#pragma mark -
#pragma Initialization

- (id)initWithSelectingContainer:(UIView<FKTextSelectingContainer> *)selectingContainer
{
    self = [super init];
    if(self)
    {
        // Assign the FKTextSelectingContainer conforming UIView
        self.selectingContainer = selectingContainer;
        
        // Set up single tap gesture
        UITapGestureRecognizer * singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userDidSingleTap:)];
        singleTapGesture.numberOfTapsRequired = 1;
        singleTapGesture.delegate = self;
        [_selectingContainer addGestureRecognizer:singleTapGesture];
        self.singleTapGesture = singleTapGesture;
        [singleTapGesture release];
        
        // Set up double tap gesture
        UITapGestureRecognizer * doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userDidDoubleTap:)];
        doubleTapGesture.numberOfTapsRequired = 2;
        doubleTapGesture.delegate = self;
        [_selectingContainer addGestureRecognizer:doubleTapGesture];
        self.doubleTapGesture = doubleTapGesture;
        [doubleTapGesture release];
    }
    return self;
}

- (void)dealloc
{
    // Clean up
    self.singleTapGesture = nil;
    self.doubleTapGesture = nil;
    self.selectingContainer = nil;
    
    [super dealloc];
}

#pragma mark -
#pragma mark Single Tap

- (void)userDidSingleTap:(UITapGestureRecognizer *)singleTapGesture
{
    
    
    // Proceed if responder is editable
    if([_selectingContainer.responder isEditable])
    {
        // Make container's responder the first responder
        [_selectingContainer.responder becomeFirstResponder];
    
        // Send tap to selection view
        [_selectingContainer.textSelectionView setCaretSelectionForPoint:[singleTapGesture locationInView:_selectingContainer.textSelectionView]];
    }
}

#pragma mark -
#pragma mark Double Tap

- (void)userDidDoubleTap:(UITapGestureRecognizer *)doubleTapGesture
{
    
        
    // Send tap to selection view
    [_selectingContainer.textSelectionView setWordSelectionForPoint:[doubleTapGesture locationInView:_selectingContainer.textSelectionView]];
}

#pragma mark -
#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    
    
    if(gestureRecognizer == self.doubleTapGesture && _selectingContainer.responder.isEditing == NO)
        return NO; // Only accept double-tap while editing
        
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    
    
    if([_selectingContainer.textContentView hitTest:[touch locationInView:_selectingContainer.textContentView] withEvent:nil] == NO)
        return NO;
    
    if(gestureRecognizer == self.doubleTapGesture && _selectingContainer.responder.isEditing == NO)
        return NO; // Only accept double-tap while editing
    
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    
    
    return NO;
}

@end