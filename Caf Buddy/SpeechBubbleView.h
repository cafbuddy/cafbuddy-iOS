
// The bubble type indicates whether it's a left-hand or right-hand bubble
typedef enum
{
	BubbleTypeLefthand = 0,
	BubbleTypeRighthand,
}
BubbleType;

// A UIView that shows a speech bubble
@interface SpeechBubbleView : UIView 
{
	NSString* text;
	BubbleType bubbleType;
}

// Calculates how big the speech bubble needs to be to fit the specified text
+ (CGSize)sizeForText:(NSString*)text;

// Configures the speech bubble
- (void)setText:(NSString*)text bubbleType:(BubbleType)bubbleType;

@end
