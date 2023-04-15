Let's say you're working with RGB colors: each color is represented with three intensities or brightnesses. You've got to choose between "linear RGB" and "sRGB". For now, we'll simplify things by ignoring the three different intensities, and assume you just have one intensity: that is, you're only dealing with shades of gray.

In a linear color-space, the relationship between the numbers you store and the intensities they represent is linear. Practically, this means that if you double the number, you double the intensity (the lightness of the gray). If you want to add two intensities together (because you're computing an intensity based on the contributions of two light sources, or because you're adding a transparent object on top of an opaque object), you can do this by just adding the two numbers together. If you're doing any kind of 2D blending or 3D shading, or almost any image processing, then you want your intensities in a linear color-space, so you can just add, subtract, multiply, and divide numbers to have the same effect on the intensities. Most color-processing and rendering algorithms only give correct results with linear RGB, unless you add extra weights to everything.

That sounds really easy, but there's a problem. The human eye's sensitivity to light is finer at low intensities than high intensities. That's to say, if you make a list of all the intensities you can distinguish, there are more dark ones than light ones. To put it another way, you can tell dark shades of gray apart better than you can with light shades of gray. In particular, if you're using 8 bits to represent your intensity, and you do this in a linear color-space, you'll end up with too many light shades, and not enough dark shades. You get banding in your dark areas, while in your light areas, you're wasting bits on different shades of near-white that the user can't tell apart.

To avoid this problem, and make the best use of those 8 bits, we tend to use sRGB. The sRGB standard tells you a curve to use, to make your colors non-linear. The curve is shallower at the bottom, so you can have more dark grays, and steeper at the top, so you have fewer light grays. If you double the number, you more than double the intensity. This means that if you add sRGB colors together, you end up with a result that is lighter than it should be. These days, most monitors interpret their input colors as sRGB. So, when you're putting a color on the screen, or storing it in an 8-bit-per-channel texture, store it as sRGB, so you make the best use of those 8 bits.

You'll notice we now have a problem: we want our colors processed in linear space, but stored in sRGB. This means you end up doing sRGB-to-linear conversion on read, and linear-to-sRGB conversion on write. As we've already said that linear 8-bit intensities don't have enough darks, this would cause problems, so there's one more practical rule: don't use 8-bit linear colors if you can avoid it. It's becoming conventional to follow the rule that 8-bit colors are always sRGB, so you do your sRGB-to-linear conversion at the same time as widening your intensity from 8 to 16 bits, or from integer to floating-point; similarly, when you've finished your floating-point processing, you narrow to 8 bits at the same time as converting to sRGB. If you follow these rules, you never have to worry about gamma correction.

When you're reading an sRGB image, and you want linear intensities, apply this formula to each intensity:

float s = read_channel();
float linear;
if (s <= 0.04045) linear = s / 12.92;
else linear = pow((s + 0.055) / 1.055, 2.4);
Going the other way, when you want to write an image as sRGB, apply this formula to each linear intensity:

float linear = do_processing();
float s;
if (linear <= 0.0031308) s = linear * 12.92;
else s = 1.055 * pow(linear, 1.0/2.4) - 0.055; ( Edited: The previous version is -0.55 )
In both cases, the floating-point s value ranges from 0 to 1, so if you're reading 8-bit integers you want to divide by 255 first, and if you're writing 8-bit integers you want to multiply by 255 last, the same way you usually would. That's all you need to know to work with sRGB.

Up to now, I've dealt with one intensity only, but there are cleverer things to do with colors. The human eye can tell different brightnesses apart better than different tints (more technically, it has better luminance resolution than chrominance), so you can make even better use of your 24 bits by storing the brightness separately from the tint. This is what YUV, YCrCb, etc. representations try to do. The Y channel is the overall lightness of the color, and uses more bits (or has more spatial resolution) than the other two channels. This way, you don't (always) need to apply a curve like you do with RGB intensities. YUV is a linear color-space, so if you double the number in the Y channel, you double the lightness of the color, but you can't add or multiply YUV colors together like you can with RGB colors, so it's not used for image processing, only for storage and transmission.

I think that answers your question, so I'll end with a quick historical note. Before sRGB, old CRTs used to have a non-linearity built into them. If you doubled the voltage for a pixel, you would more than double the intensity. How much more was different for each monitor, and this parameter was called the gamma. This behavior was useful because it meant you could get more darks than lights, but it also meant you couldn't tell how bright your colors would be on the user's CRT, unless you calibrated it first. Gamma correction means transforming the colors you start with (probably linear) and transforming them for the gamma of the user's CRT. OpenGL comes from this era, which is why its sRGB behavior is sometimes a little confusing. But GPU vendors now tend to work with the convention I described above: that when you're storing an 8-bit intensity in a texture or framebuffer, it's sRGB, and when you're processing colors, it's linear. For example, an OpenGL ES 3.0, each framebuffer and texture has an "sRGB flag" you can turn on to enable automatic conversion when reading and writing. You don't need to explicitly do sRGB conversion or gamma correction at all.