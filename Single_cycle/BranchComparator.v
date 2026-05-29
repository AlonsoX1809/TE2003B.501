module BranchComparator (
    input  Zero,
    input  Branch,
    input  Jump,
    output PCSrc
);

    assign PCSrc = (Branch & Zero) | Jump;

endmodule