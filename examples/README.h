<html>
<head>
<title>Examples programs written in <tt>noweb</tt></title>
</head>
<body>
<h1>Noweb example programs</h1>
All but one of 
these examples have had their documentation parts converted automatically
from LaTeX to HTML. 
(Can you tell which one?)
Except for <a href=breakmodel.html>breakmodel</a>,
each example file is a fragment of a larger
program.
<p>
The typical command line used to create one of these documents is:
<pre>
noweave -filter l2h -index -autodefs c -html compress.nw > compress.html
</pre>
for various values of <tt>c</tt> :-)
<p>
The example programs are:
<dl>
<dt><a href=breakmodel.html>breakmodel</a><dd>
		A formal model of breakpoints using the
			Promela modeling language.
<dt><a href=compress.html>compress</a><dd>
  A library that modifies the <t>open</t>, <t>close</t>, <t>read</t>,
  and <t>write</t> system calls (along with some others) to
  transparently read and write files in Unix <t>compress</t> format.
  Graciously contributed by 
  <a href=http://www.cs.princeton.edu/~blume>Matthias Blume</a>
<dt><a href=dag.html>dag</a><dd>
		Fragment of an <a href=http://www.cs.arizona.edu/icon/>Icon</a>
		 program that compiles
			patterns into decision-tree pattern-matching
			code.  tree.nw builds the decision trees;
			dag.nw turns them into dags.
<dt><a href=graphs.html>graphs</a><dd>
		Several graphs written in 
	<a href=http://www.cs.utk.edu/~plank/plank/jgraph/jgraph.html>jgraph</a>.
<dt><a href=mipscoder.html>mipscoder</a><dd>
		Part of the original MIPS code generator from
			Standard ML of New Jersey.  Written in Standard ML.
<dt><a href=primes.html>primes</a><dd>
		noweb version of DEK's original prime-number program.
		I got tired of typing and never entered all the text.
<dt><a href=scanner.html>scanner</a><dd>
		Part of a student compiler project.  Includes
			C code and lex and yacc specifications, all in
			a single file. 
<dt><a href=solver.html>solver</a><dd>
An equation solver, published in <em>Software---Practice &amp; Experience</em>.
The <A href=/~nr/pubs/solver.ps>PostScript</a> is probably easier to read.
<dt><a href=test.html>test</a><dd>
		A simple test file.
<dt><a href=tree.html>tree</a><dd>
		Fragment of an <a href=http://www.cs.arizona.edu/icon/>Icon</a>
	 program that compiles
			patterns into decision-tree pattern-matching
			code.  tree.nw builds the decision trees;
			dag.nw turns them into dags.
<dt><a href=wc.html>wc</a><dd>
  An re-implementation of the example word-count program from Don
  Knuth's book on literate programming.
  This example is as exact a copy as possible; no
			attempt was made to improve the code.
  <a href="wcni.html">Here</a> is a version without identifier
  cross-reference, which gives it a cleaner look.
  <a href="wc.nw.html">Here</a> you can see a plain-text
  rendering of the <tt>noweb</tt> source.
</dl>
</body>
