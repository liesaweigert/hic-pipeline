#CAPER docker quay.io/encode-dcc/hic-pipeline:template

import "../../workflow/main_workflow/hic.wdl" as hic

workflow test_no_call_loops {
    File input_hic
    Boolean no_call_loops
    # Added in PIP-622, not actually used by test
    String restriction_enzyme = "MboI"

    call hic.hic { input:
        input_hic = input_hic,
        no_call_loops = no_call_loops,
        restriction_enzyme = restriction_enzyme
    }
    output {
        File? domains = hic.out_tads
    }
}