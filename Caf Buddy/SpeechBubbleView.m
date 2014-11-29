
#import "SpeechBubbleView.h"
#import <UIKit/UIKit.h>

static UIFont* font = nil;
static UIImage* lefthandImage = nil;
static UIImage* righthandImage = nil;

const CGFloat VertPadding = 4;       // additional padding around the edges
const CGFloat HorzPadding = 4;

const CGFloat TextLeftMargin = 17;   // insets for the text
const CGFloat TextRightMargin = 15;
const CGFloat TextTopMargin = 10;
const CGFloat TextBottomMargin = 11;

const CGFloat MinBubbleWidth = 50;   // minimum width of the bubble
const CGFloat MinBubbleHeight = 40;  // minimum height of the bubble

const CGFloat WrapWidth = 200;       // maximum width of text in the bubble

@implementation SpeechBubbleView

+ (void)initialize
{
	if (self == [SpeechBubbleView class])
	{
		font = [[UIFont systemFontOfSize:[UIFont systemFontSize]] retain];

		lefthandImage = [[[UIImage imageNamed:@"BubbleLefthand"]
			stretchableImageWithLeftCapWidth:20 topCapHeight:19] retain];

		righthandImage = [[[UIImage imageNamed:@"BubbleRighthand"]
			stretchableImageWithLeftCapWidth:20 topCapHeight:19] retain];
	}
}

+ (CGSize)sizeForText:(NSString*)text
{
	CGSize textSize = [text sizeWithFont:font
		constrainedToSize:CGSizeMake(WrapWidth, 9999)
		lineBreakMode:UILineBreakModeWordWrap];

	CGSize bubbleSize;
	bubbleSize.width = textSize.width + TextLeftMargin + TextRightMargin;
	bubbleSize.height = textSize.height + TextTopMargin + TextBottomMargin;

	if (bubbleSize.width < MinBubbleWidth)
		bubbleSize.width = MinBubbleWidth;

	if (bubbleSize.height < MinBubbleHeight)
		bubbleSize.height = MinBubbleHeight;

	bubbleSize.width += HorzPadding*2;
	bubbleSize.height += VertPadding*2;

	return bubbleSize;
}

- (void)drawRect:(CGRect)rect
{
	[self.backgroundColor setFill];
	UIRectFill(rect);

	CGRect bubbleRect = CGRectInset(self.bounds, VertPadding, HorzPadding);

	CGRect textRect;
	textRect.origin.y = bubbleRect.origin.y + TextTopMargin;
	textRect.size.width = bubbleRect.size.width - TextLeftMargin - TextRightMargin;
	textRect.size.height = bubbleRect.size.height - TextTopMargin - TextBottomMargin;

	if (bubbleType == BubbleTypeLefthand)
	{
		[lefthandImage drawInRect:bubbleRect];
		textRect.origin.x = bubbleRect.origin.x + TextLeftMargin;
	}
	else
	{
		[righthandImage drawInRect:bubbleRect];
		textRect.origin.x = bubbleRect.origin.x + TextRightMargin;
	}

	[[UIColor blackColor] set];
	[text drawInRect:textRect withFont:font lineBreakMode:UILineBreakModeWordWrap];
}

- (void)setText:(NSString*)newText bubbleType:(BubbleType)newBubbleType
{
	[text release];
	text = [newText copy];
	bubbleType = newBubbleType;
	[self setNeedsDisplay];
}

- (void)dealloc
{
	[text release];
	[super dealloc];
}

@end
