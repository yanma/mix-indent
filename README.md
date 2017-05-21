# mix-indent

When both tab and space are used as indent, mix-indent visualizes them.

# Demo

The picture below shows how this plugin works. mixed_sample.c has two different indents as below.

- Indent with space (Line 4 and 10)
- Indent with tab (Line 6, 7, 8)

Because the number of lines with spaced indent is smaller than tabbed indent, this plugin highlights tabbed indents. In the opposite case(e.g. the number of spaced indents > tabbed indents), it highlights spaced indents.

![fig1](https://github.com/yanma/mix-indent/blob/def744d2f5cad770d1e39df6b6d6b26117609e0c/fig1.png)
