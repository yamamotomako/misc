<h1>Visualizing-somatic-vs-germinal</h1>

<h2>Visualizing feature quantity of somatic vs germinal mutation by plots.</h2>


<h3>Dependency</h3>
python 2.7.x


<hr>
<h3>Install</h3>
<pre><code>
git clone https://github.com/yamamotomako/Visualizing-somatic-vs-germinal<br>
</code></pre>


<hr>
<h3>Usage</h3>
<pre><code>
cd ./Visualizing-somatic-vs-germinal<br>
<br>
bash ./runall.sh /(path of sample-list) /(path of output directory)<br>
(eg) bash ./src/runall.sh ./data/sample_list.csv ./result<br>
<br><br>
<h4>---NOTE---</h4>
"sample_list.csv" must include sample name and path of result file after mutation call executed by genomon.<br>
And those must be split by commma.<br>
<br>
(eg)RCC252T,/home/genomon_result_tumor_normal/mutation/RCC252T/RCC252T.genomon_mutation.result.filt.txt<br>
</code></pre>



<h4>success log</h4>
Console will write out the following log.<br>
<pre><code>
filtering by exon misrate indel TN...<br>
filtering by exon misrate indel N...<br>
filtering secondly by depth N...<br>
categorizing into somatic germline others...<br>
[1] "building mutation count..."<br>
[1] "building dbsnp, cosmic, exac..."<br>

</code></pre>


<h4>output</h4>
Output image files are...<br>
<pre><code>
./output path/mutation_count.png<br>
./output path/dbsnp.png<br>
./output path/cosmic.png<br>
./output path/exac.png<br>
</code></pre>




