# TraCeR summarise Docker operator

##### Description

The TraCeR Docker operator implements the TraCeR summarise tool inside Tercen.

TraCeR is a tool developed by Michael Stubbington to reconstruct the sequences of T-cell receptors from single-cell RNA-seq data.

The TraCer summarise command processes output from a previous TraCeR run and compiles the results.

More information on TraCeR can be found in the [paper describing it](http://dx.doi.org/10.1038/nmeth.3800) or in the [tool's GitHub page](https://github.com/Teichlab/tracer).

##### Usage

Input projection|.
---|---
Leave empty

For this operator to work there must be two folders on the file system (replace <username> and <projectname> with the user and project names for this run):
    
    - /var/lib/tercen/external/read/<username>/<project_name>
    - /var/lib/tercen/external/write/<username>/<project_name>/tracer_output

The operator will look for the TraCeR output present in the second of these folders. If the TraCeR operator was successfully run before on the same project, the output will already be there. If not running this operator as part of the entire workflow, copy the desired folders into `/var/lib/tercen/external/write/<username>/<project_name>/tracer_output`.

For output, the operator will create a `filtered_TCRAB_summary` folder with the results of TraCeR summarise and a `summarise_output.tsv` file with the results of the `collect_TRA_TRB_in_fasta.py` script, both in the `/var/lib/tercen/external/write/<username>/<project_name>/tracer_output` folder.


