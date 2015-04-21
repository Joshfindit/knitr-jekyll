---
layout: post
title:  "A Tufte-style Jekyll blog powered by servr and knitr"
categories: [jekyll, rstats]
tags: [knitr, servr, httpuv, websocket]
---

<span class='newthought'>This post introduces</span> [my fork](http://github.com/cpsievert/knitr-jekyll) of Yihui's [knitr-jekyll](https://github.com/yihui/knitr-jekyll) that swaps the default theme with [tufte-jekyll](https://github.com/clayh53/tufte-jekyll). I recommend reading [this post](http://yihui.name/knitr-jekyll/2014/09/jekyll-with-knitr.html) to learn about why `servr + knitr + jekyll` is awesome and (if needed) use [this post](http://clayh53.github.io/tufte-jekyll/articles/15/tufte-style-jekyll-blog/) as a reference for "tufte-jekyll liquid tags" that do stuff like this <span class='newthought'>pointless side note</span>. There are a lot moving parts, so if you use this and run into issues, [please let me know](https://github.com/cpsievert/knitr-jekyll)!



## Special chunk options

There are a few **knitr** [chunk options](http://yihui.name/knitr/options/) that conveniently map your output to special formatting supported by the tufte-jekyll layout. You might find it useful to [view the source](https://raw.githubusercontent.com/cpsievert/knitr-jekyll/gh-pages/_source/2015-04-20-jekyll-tufte-servr.Rmd) for this post to see the actual chunk option settings.

### Figure options

By default, the `fig.width` chunk option is equal to 7 inches. That translates to about 3/4 of the textwidth (assuming the zoom of your browser window is at 100%). 


{% highlight r %}
library(ggplot2)
p <- ggplot(diamonds, aes(carat)) 
p + geom_histogram()
{% endhighlight %}

<span class='marginnote'>Figure 1: A nice plot that is not quite wide enough.</span><img class='fullwidth' src='/figure/source/2015-04-20-jekyll-tufte-servr/skinny-1.png'/>

If we increase `fig.width` to a ridiculous number, say 20 inches, it will still be constrained to the text width, even by changing `fig.width` to 20 inches. 


{% highlight r %}
p + geom_histogram(aes(y = ..density..))
{% endhighlight %}

<span class='marginnote'>Figure 2: The `fig.height` for this chunk is same as Figure 1, but the `fig.width` is now 20. Since the width is constrained by the text width, the figure is shrunken quite a bit.</span><img class='fullwidth' src='/figure/source/2015-04-20-jekyll-tufte-servr/wide-1.png'/>

By constraining the figure width, it will ensure that figure captions (set via `fig.cap`) appear correctly in the side margin. If you need a wider figure, set the `fig.fullwidth` chunk option equal to `TRUE`.


{% highlight r %}
p + geom_point(aes(y = price), alpha = 0.2) + 
  facet_wrap(~cut, nrow = 1, scales = "free_x") +
  geom_smooth(aes(y = price, fill = cut))
{% endhighlight %}

<div><img class='fullwidth' src='/figure/source/2015-04-20-jekyll-tufte-servr/full-1.png'/></div><p><span class='marginnote'>Figure 3: Full width plot</span></p>

To place figures in the margin, set the `fig.margin` chunk option equal to `TRUE`.


{% highlight r %}
tmp <- tempfile()
user <- "http://user2014.stat.ucla.edu/images/useR-large.png"
download.file(user, tmp)
img <- png::readPNG(tmp)
plot(0:1, type = 'n', xlab = "", ylab = "")
lim <- par()
rasterImage(img, lim$usr[1], lim$usr[3], lim$usr[2], lim$usr[4])
{% endhighlight %}

<span class='marginnote'><img class='fullwidth' src='/figure/source/2015-04-20-jekyll-tufte-servr/margin-1.png'/>Figure 4: useR logo</span>

{% highlight r %}
unlink(tmp)
{% endhighlight %}


## Sizing terminal output
 
The default `R` terminal output width is 80, which is a bit too big for the styling of this blog, but a width of 55 works pretty well:


{% highlight r %}
options(width = 55, digits = 3)
(x <- rnorm(40))
{% endhighlight %}



{% highlight text %}
##  [1]  0.4779  1.6193  0.8740 -0.3443  0.6708 -0.3595
##  [7] -0.7876  0.4357 -1.0638  0.7807 -1.1370 -0.3950
## [13]  0.7874 -0.8808  2.3192  0.0172 -0.7124 -2.2382
## [19] -1.0699  2.0770  1.4668  1.1459  0.9196 -0.6784
## [25]  1.0554 -1.9228 -0.2850  0.0023 -0.4039 -2.1761
## [31]  2.0912 -0.8660  1.1960  0.3555  0.5527  1.4020
## [37]  1.8807 -0.7763 -0.5862  2.2027
{% endhighlight %}

## Mathjax

What's that? You can't live without math equations?

<script type="math/tex; mode=display">
x = {-b \pm \sqrt{b^2-4ac} \over 2a}.
</script>

If you want inline, <script type="math/tex"> \alpha </script>

## Tables


At any time, you can add an arbitrary "marginnote" like this:

{% highlight html %}
<span class='marginnote'>
  Table 1: Diamonds data
</span>
{% endhighlight %}

This can be quite useful especially for tables.

<span class='marginnote'> Table 1: Diamonds data </span>


{% highlight r %}
knitr::kable(head(diamonds), "markdown")
{% endhighlight %}



| carat|cut       |color |clarity | depth| table| price|    x|    y|    z|
|-----:|:---------|:-----|:-------|-----:|-----:|-----:|----:|----:|----:|
|  0.23|Ideal     |E     |SI2     |  61.5|    55|   326| 3.95| 3.98| 2.43|
|  0.21|Premium   |E     |SI1     |  59.8|    61|   326| 3.89| 3.84| 2.31|
|  0.23|Good      |E     |VS1     |  56.9|    65|   327| 4.05| 4.07| 2.31|
|  0.29|Premium   |I     |VS2     |  62.4|    58|   334| 4.20| 4.23| 2.63|
|  0.31|Good      |J     |SI2     |  63.3|    58|   335| 4.34| 4.35| 2.75|
|  0.24|Very Good |J     |VVS2    |  62.8|    57|   336| 3.94| 3.96| 2.48|

## Sidenotes

Similar to a 'marginnote' is a 'sidenote' which works like this
<sup class='sidenote-number'>
 1
</sup>
<span class='sidenote'>
  <sup class='sidenote-number'> 1 </sup> 
  Sidenotes are kind of like footnotes that appear in the side margin.
</span> 

{% highlight html %}
<sup class='sidenote-number'>
 1
</sup>
<span class='sidenote'>
  <sup class='sidenote-number'> 1 </sup> 
  Sidenotes are kind of like footnotes that appear in the side margin.
</span> 
{% endhighlight %}
