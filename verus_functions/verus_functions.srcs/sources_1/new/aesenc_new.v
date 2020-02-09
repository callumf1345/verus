`timescale 1ns / 1ps

module aesenc_new(
    input clk,//I think only the top 128 bits are used at all?
    input [511:0] s_in, //input identical to c visually
    input [127:0] rk, //input identical to c visually
    output [127:0] s_out
    );
    
localparam sbox  = { 8'h63, 8'h7c, 8'h77, 8'h7b, 8'hf2, 8'h6b, 8'h6f, 8'hc5, 8'h30, 8'h01, 8'h67, 8'h2b, 8'hfe,
  8'hd7, 8'hab, 8'h76, 8'hca, 8'h82, 8'hc9, 8'h7d, 8'hfa, 8'h59, 8'h47, 8'hf0, 8'had, 8'hd4,
  8'ha2, 8'haf, 8'h9c, 8'ha4, 8'h72, 8'hc0, 8'hb7, 8'hfd, 8'h93, 8'h26, 8'h36, 8'h3f, 8'hf7,
  8'hcc, 8'h34, 8'ha5, 8'he5, 8'hf1, 8'h71, 8'hd8, 8'h31, 8'h15, 8'h04, 8'hc7, 8'h23, 8'hc3,
  8'h18, 8'h96, 8'h05, 8'h9a, 8'h07, 8'h12, 8'h80, 8'he2, 8'heb, 8'h27, 8'hb2, 8'h75, 8'h09,
  8'h83, 8'h2c, 8'h1a, 8'h1b, 8'h6e, 8'h5a, 8'ha0, 8'h52, 8'h3b, 8'hd6, 8'hb3, 8'h29, 8'he3,
  8'h2f, 8'h84, 8'h53, 8'hd1, 8'h00, 8'hed, 8'h20, 8'hfc, 8'hb1, 8'h5b, 8'h6a, 8'hcb, 8'hbe,
  8'h39, 8'h4a, 8'h4c, 8'h58, 8'hcf, 8'hd0, 8'hef, 8'haa, 8'hfb, 8'h43, 8'h4d, 8'h33, 8'h85,
  8'h45, 8'hf9, 8'h02, 8'h7f, 8'h50, 8'h3c, 8'h9f, 8'ha8, 8'h51, 8'ha3, 8'h40, 8'h8f, 8'h92,
  8'h9d, 8'h38, 8'hf5, 8'hbc, 8'hb6, 8'hda, 8'h21, 8'h10, 8'hff, 8'hf3, 8'hd2, 8'hcd, 8'h0c,
  8'h13, 8'hec, 8'h5f, 8'h97, 8'h44, 8'h17, 8'hc4, 8'ha7, 8'h7e, 8'h3d, 8'h64, 8'h5d, 8'h19,
  8'h73, 8'h60, 8'h81, 8'h4f, 8'hdc, 8'h22, 8'h2a, 8'h90, 8'h88, 8'h46, 8'hee, 8'hb8, 8'h14,
  8'hde, 8'h5e, 8'h0b, 8'hdb, 8'he0, 8'h32, 8'h3a, 8'h0a, 8'h49, 8'h06, 8'h24, 8'h5c, 8'hc2,
  8'hd3, 8'hac, 8'h62, 8'h91, 8'h95, 8'he4, 8'h79, 8'he7, 8'hc8, 8'h37, 8'h6d, 8'h8d, 8'hd5,
  8'h4e, 8'ha9, 8'h6c, 8'h56, 8'hf4, 8'hea, 8'h65, 8'h7a, 8'hae, 8'h08, 8'hba, 8'h78, 8'h25,
  8'h2e, 8'h1c, 8'ha6, 8'hb4, 8'hc6, 8'he8, 8'hdd, 8'h74, 8'h1f, 8'h4b, 8'hbd, 8'h8b, 8'h8a,
  8'h70, 8'h3e, 8'hb5, 8'h66, 8'h48, 8'h03, 8'hf6, 8'h0e, 8'h61, 8'h35, 8'h57, 8'hb9, 8'h86,
  8'hc1, 8'h1d, 8'h9e, 8'he1, 8'hf8, 8'h98, 8'h11, 8'h69, 8'hd9, 8'h8e, 8'h94, 8'h9b, 8'h1e,
  8'h87, 8'he9, 8'hce, 8'h55, 8'h28, 8'hdf, 8'h8c, 8'ha1, 8'h89, 8'h0d, 8'hbf, 8'he6, 8'h42,
  8'h68, 8'h41, 8'h99, 8'h2d, 8'h0f, 8'hb0, 8'h54, 8'hbb, 8'h16 };
  //unpacked because sysverilog won't allow packed localparams
  localparam [2047:0] saes_data_default = { 8'h63, 8'h7c, 8'h77, 8'h7b, 8'hf2, 8'h6b, 8'h6f, 8'hc5,
    8'h30, 8'h01, 8'h67, 8'h2b, 8'hfe, 8'hd7, 8'hab, 8'h76,
    8'hca, 8'h82, 8'hc9, 8'h7d, 8'hfa, 8'h59, 8'h47, 8'hf0,
    8'had, 8'hd4, 8'ha2, 8'haf, 8'h9c, 8'ha4, 8'h72, 8'hc0,
    8'hb7, 8'hfd, 8'h93, 8'h26, 8'h36, 8'h3f, 8'hf7, 8'hcc,
    8'h34, 8'ha5, 8'he5, 8'hf1, 8'h71, 8'hd8, 8'h31, 8'h15,
    8'h04, 8'hc7, 8'h23, 8'hc3, 8'h18, 8'h96, 8'h05, 8'h9a,
    8'h07, 8'h12, 8'h80, 8'he2, 8'heb, 8'h27, 8'hb2, 8'h75,
    8'h09, 8'h83, 8'h2c, 8'h1a, 8'h1b, 8'h6e, 8'h5a, 8'ha0,
    8'h52, 8'h3b, 8'hd6, 8'hb3, 8'h29, 8'he3, 8'h2f, 8'h84,
    8'h53, 8'hd1, 8'h00, 8'hed, 8'h20, 8'hfc, 8'hb1, 8'h5b,
    8'h6a, 8'hcb, 8'hbe, 8'h39, 8'h4a, 8'h4c, 8'h58, 8'hcf,
    8'hd0, 8'hef, 8'haa, 8'hfb, 8'h43, 8'h4d, 8'h33, 8'h85,
    8'h45, 8'hf9, 8'h02, 8'h7f, 8'h50, 8'h3c, 8'h9f, 8'ha8,
    8'h51, 8'ha3, 8'h40, 8'h8f, 8'h92, 8'h9d, 8'h38, 8'hf5,
    8'hbc, 8'hb6, 8'hda, 8'h21, 8'h10, 8'hff, 8'hf3, 8'hd2,
    8'hcd, 8'h0c, 8'h13, 8'hec, 8'h5f, 8'h97, 8'h44, 8'h17,
    8'hc4, 8'ha7, 8'h7e, 8'h3d, 8'h64, 8'h5d, 8'h19, 8'h73,
    8'h60, 8'h81, 8'h4f, 8'hdc, 8'h22, 8'h2a, 8'h90, 8'h88,
    8'h46, 8'hee, 8'hb8, 8'h14, 8'hde, 8'h5e, 8'h0b, 8'hdb,
    8'he0, 8'h32, 8'h3a, 8'h0a, 8'h49, 8'h06, 8'h24, 8'h5c,
    8'hc2, 8'hd3, 8'hac, 8'h62, 8'h91, 8'h95, 8'he4, 8'h79,
    8'he7, 8'hc8, 8'h37, 8'h6d, 8'h8d, 8'hd5, 8'h4e, 8'ha9,
    8'h6c, 8'h56, 8'hf4, 8'hea, 8'h65, 8'h7a, 8'hae, 8'h08,
    8'hba, 8'h78, 8'h25, 8'h2e, 8'h1c, 8'ha6, 8'hb4, 8'hc6,
    8'he8, 8'hdd, 8'h74, 8'h1f, 8'h4b, 8'hbd, 8'h8b, 8'h8a,
    8'h70, 8'h3e, 8'hb5, 8'h66, 8'h48, 8'h03, 8'hf6, 8'h0e,
    8'h61, 8'h35, 8'h57, 8'hb9, 8'h86, 8'hc1, 8'h1d, 8'h9e,
    8'he1, 8'hf8, 8'h98, 8'h11, 8'h69, 8'hd9, 8'h8e, 8'h94,
    8'h9b, 8'h1e, 8'h87, 8'he9, 8'hce, 8'h55, 8'h28, 8'hdf,
    8'h8c, 8'ha1, 8'h89, 8'h0d, 8'hbf, 8'he6, 8'h42, 8'h68,
    8'h41, 8'h99, 8'h2d, 8'h0f, 8'hb0, 8'h54, 8'hbb, 8'h16 };
   
   
localparam [32767:0] saes  ={128'hc66363a5f87c7c84ee777799f67b7b8d, 128'hfff2f20dd66b6bbdde6f6fb191c5c554,128'h6030305002010103ce6767a9562b2b7d,128'he7fefe19b5d7d7624dababe6ec76769a,128'h8fcaca451f82829d89c9c940fa7d7d87,128'heffafa15b25959eb8e4747c9fbf0f00b,128'h41adadecb3d4d4675fa2a2fd45afafea,128'h239c9cbf53a4a4f7e47272969bc0c05b,128'h75b7b7c2e1fdfd1c3d9393ae4c26266a,128'h6c36365a7e3f3f41f5f7f70283cccc4f,128'h6834345c51a5a5f4d1e5e534f9f1f108,128'he2717193abd8d873623131532a15153f,128'h0804040c95c7c752462323659dc3c35e,128'h30181828379696a10a05050f2f9a9ab5,128'h0e070709241212361b80809bdfe2e23d,128'hcdebeb264e2727697fb2b2cdea75759f,128'h1209091b1d83839e582c2c74341a1a2e,128'h361b1b2ddc6e6eb2b45a5aee5ba0a0fb,128'ha45252f6763b3b4db7d6d6617db3b3ce,128'h5229297bdde3e33e5e2f2f7113848497,128'ha65353f5b9d1d16800000000c1eded2c,128'h40202060e3fcfc1f79b1b1c8b65b5bed,128'hd46a6abe8dcbcb4667bebed97239394b,128'h944a4ade984c4cd4b05858e885cfcf4a,128'hbbd0d06bc5efef2a4faaaae5edfbfb16,128'h864343c59a4d4dd76633335511858594,128'h8a4545cfe9f9f91004020206fe7f7f81,128'ha05050f0783c3c44259f9fba4ba8a8e3,128'ha25151f35da3a3fe804040c0058f8f8a,128'h3f9292ad219d9dbc70383848f1f5f504,128'h63bcbcdf77b6b6c1afdada7542212163,128'h20101030e5ffff1afdf3f30ebfd2d26d,128'h81cdcd4c180c0c1426131335c3ecec2f,128'hbe5f5fe1359797a2884444cc2e171739,128'h93c4c45755a7a7f2fc7e7e827a3d3d47,128'hc86464acba5d5de73219192be6737395,128'hc06060a0198181989e4f4fd1a3dcdc7f,128'h44222266542a2a7e3b9090ab0b888883,128'h8c4646cac7eeee296bb8b8d32814143c,128'ha7dede79bc5e5ee2160b0b1daddbdb76,128'hdbe0e03b64323256743a3a4e140a0a1e,128'h924949db0c06060a4824246cb85c5ce4,128'h9fc2c25dbdd3d36e43acacefc46262a6,128'h399191a8319595a4d3e4e437f279798b,128'hd5e7e7328bc8c8436e373759da6d6db7,128'h018d8d8cb1d5d5649c4e4ed249a9a9e0,128'hd86c6cb4ac5656faf3f4f407cfeaea25,128'hca6565aff47a7a8e47aeaee910080818,128'h6fbabad5f07878884a25256f5c2e2e72,128'h381c1c2457a6a6f173b4b4c797c6c651,128'hcbe8e823a1dddd7ce874749c3e1f1f21,128'h964b4bdd61bdbddc0d8b8b860f8a8a85,128'he07070907c3e3e4271b5b5c4cc6666aa,128'h904848d806030305f7f6f6011c0e0e12,128'hc26161a36a35355fae5757f969b9b9d0,128'h1786869199c1c1583a1d1d27279e9eb9,128'hd9e1e138ebf8f8132b9898b322111133,128'hd26969bba9d9d970078e8e89339494a7,128'h2d9b9bb63c1e1e2215878792c9e9e920,128'h87cece49aa5555ff50282878a5dfdf7a,128'h038c8c8f59a1a1f8098989801a0d0d17,128'h65bfbfdad7e6e631844242c6d06868b8,128'h824141c3299999b05a2d2d771e0f0f11,128'h7bb0b0cba85454fc6dbbbbd62c16163a,128'ha5c6636384f87c7c99ee77778df67b7b,128'h0dfff2f2bdd66b6bb1de6f6f5491c5c5,128'h5060303003020101a9ce67677d562b2b,128'h19e7fefe62b5d7d7e64dabab9aec7676,128'h458fcaca9d1f82824089c9c987fa7d7d,128'h15effafaebb25959c98e47470bfbf0f0,128'hec41adad67b3d4d4fd5fa2a2ea45afaf,128'hbf239c9cf753a4a496e472725b9bc0c0,128'hc275b7b71ce1fdfdae3d93936a4c2626,128'h5a6c3636417e3f3f02f5f7f74f83cccc,128'h5c683434f451a5a534d1e5e508f9f1f1,128'h93e2717173abd8d8536231313f2a1515,128'h0c0804045295c7c7654623235e9dc3c3,128'h28301818a13796960f0a0505b52f9a9a,128'h090e0707362412129b1b80803ddfe2e2,128'h26cdebeb694e2727cd7fb2b29fea7575,128'h1b1209099e1d838374582c2c2e341a1a,128'h2d361b1bb2dc6e6eeeb45a5afb5ba0a0,128'hf6a452524d763b3b61b7d6d6ce7db3b3,128'h7b5229293edde3e3715e2f2f97138484,128'hf5a6535368b9d1d1000000002cc1eded,128'h604020201fe3fcfcc879b1b1edb65b5b,128'hbed46a6a468dcbcbd967bebe4b723939,128'hde944a4ad4984c4ce8b058584a85cfcf,128'h6bbbd0d02ac5efefe54faaaa16edfbfb,128'hc5864343d79a4d4d5566333394118585,128'hcf8a454510e9f9f90604020281fe7f7f,128'hf0a0505044783c3cba259f9fe34ba8a8,128'hf3a25151fe5da3a3c08040408a058f8f,128'had3f9292bc219d9d4870383804f1f5f5,128'hdf63bcbcc177b6b675afdada63422121,128'h302010101ae5ffff0efdf3f36dbfd2d2,128'h4c81cdcd14180c0c352613132fc3ecec,128'he1be5f5fa2359797cc884444392e1717,128'h5793c4c4f255a7a782fc7e7e477a3d3d,128'hacc86464e7ba5d5d2b32191995e67373,128'ha0c0606098198181d19e4f4f7fa3dcdc,128'h664422227e542a2aab3b9090830b8888,128'hca8c464629c7eeeed36bb8b83c281414,128'h79a7dedee2bc5e5e1d160b0b76addbdb,128'h3bdbe0e0566432324e743a3a1e140a0a,128'hdb9249490a0c06066c482424e4b85c5c,128'h5d9fc2c26ebdd3d3ef43acaca6c46262,128'ha8399191a431959537d3e4e48bf27979,128'h32d5e7e7438bc8c8596e3737b7da6d6d,128'h8c018d8d64b1d5d5d29c4e4ee049a9a9,128'hb4d86c6cfaac565607f3f4f425cfeaea,128'hafca65658ef47a7ae947aeae18100808,128'hd56fbaba88f078786f4a2525725c2e2e,128'h24381c1cf157a6a6c773b4b45197c6c6,128'h23cbe8e87ca1dddd9ce87474213e1f1f,128'hdd964b4bdc61bdbd860d8b8b850f8a8a,128'h90e07070427c3e3ec471b5b5aacc6666,128'hd89048480506030301f7f6f6121c0e0e,128'ha3c261615f6a3535f9ae5757d069b9b9,128'h911786865899c1c1273a1d1db9279e9e,128'h38d9e1e113ebf8f8b32b989833221111,128'hbbd2696970a9d9d989078e8ea7339494,128'hb62d9b9b223c1e1e9215878720c9e9e9,128'h4987ceceffaa5555785028287aa5dfdf,128'h8f038c8cf859a1a180098989171a0d0d,128'hda65bfbf31d7e6e6c6844242b8d06868,128'hc3824141b0299999775a2d2d111e0f0f,128'hcb7bb0b0fca85454d66dbbbb3a2c1616,128'h63a5c6637c84f87c7799ee777b8df67b,128'hf20dfff26bbdd66b6fb1de6fc55491c5,128'h305060300103020167a9ce672b7d562b,128'hfe19e7fed762b5d7abe64dab769aec76,128'hca458fca829d1f82c94089c97d87fa7d,128'hfa15effa59ebb25947c98e47f00bfbf0,128'hadec41add467b3d4a2fd5fa2afea45af,128'h9cbf239ca4f753a47296e472c05b9bc0,128'hb7c275b7fd1ce1fd93ae3d93266a4c26,128'h365a6c363f417e3ff702f5f7cc4f83cc,128'h345c6834a5f451a5e534d1e5f108f9f1,128'h7193e271d873abd831536231153f2a15,128'h040c0804c75295c723654623c35e9dc3,128'h1828301896a13796050f0a059ab52f9a,128'h07090e0712362412809b1b80e23ddfe2,128'heb26cdeb27694e27b2cd7fb2759fea75,128'h091b1209839e1d832c74582c1a2e341a,128'h1b2d361b6eb2dc6e5aeeb45aa0fb5ba0,128'h52f6a4523b4d763bd661b7d6b3ce7db3,128'h297b5229e33edde32f715e2f84971384,128'h53f5a653d168b9d100000000ed2cc1ed,128'h20604020fc1fe3fcb1c879b15bedb65b,128'h6abed46acb468dcbbed967be394b7239,128'h4ade944a4cd4984c58e8b058cf4a85cf,128'hd06bbbd0ef2ac5efaae54faafb16edfb,128'h43c586434dd79a4d3355663385941185,128'h45cf8a45f910e9f9020604027f81fe7f,128'h50f0a0503c44783c9fba259fa8e34ba8,128'h51f3a251a3fe5da340c080408f8a058f,128'h92ad3f929dbc219d38487038f504f1f5,128'hbcdf63bcb6c177b6da75afda21634221,128'h10302010ff1ae5fff30efdf3d26dbfd2,128'hcd4c81cd0c14180c13352613ec2fc3ec,128'h5fe1be5f97a2359744cc884417392e17,128'hc45793c4a7f255a77e82fc7e3d477a3d,128'h64acc8645de7ba5d192b32197395e673,128'h60a0c060819819814fd19e4fdc7fa3dc,128'h226644222a7e542a90ab3b9088830b88,128'h46ca8c46ee29c7eeb8d36bb8143c2814,128'hde79a7de5ee2bc5e0b1d160bdb76addb,128'he03bdbe0325664323a4e743a0a1e140a,128'h49db9249060a0c06246c48245ce4b85c,128'hc25d9fc2d36ebdd3acef43ac62a6c462,128'h91a8399195a43195e437d3e4798bf279,128'he732d5e7c8438bc837596e376db7da6d,128'h8d8c018dd564b1d54ed29c4ea9e049a9,128'h6cb4d86c56faac56f407f3f4ea25cfea,128'h65afca657a8ef47aaee947ae08181008,128'hbad56fba7888f078256f4a252e725c2e,128'h1c24381ca6f157a6b4c773b4c65197c6,128'he823cbe8dd7ca1dd749ce8741f213e1f,128'h4bdd964bbddc61bd8b860d8b8a850f8a,128'h7090e0703e427c3eb5c471b566aacc66,128'h48d8904803050603f601f7f60e121c0e,128'h61a3c261355f6a3557f9ae57b9d069b9,128'h86911786c15899c11d273a1d9eb9279e,128'he138d9e1f813ebf898b32b9811332211,128'h69bbd269d970a9d98e89078e94a73394,128'h9bb62d9b1e223c1e87921587e920c9e9,128'hce4987ce55ffaa5528785028df7aa5df,128'h8c8f038ca1f859a1898009890d171a0d,128'hbfda65bfe631d7e642c6844268b8d068,128'h41c3824199b029992d775a2d0f111e0f,128'hb0cb7bb054fca854bbd66dbb163a2c16,128'h6363a5c67c7c84f8777799ee7b7b8df6,128'hf2f20dff6b6bbdd66f6fb1dec5c55491,128'h30305060010103026767a9ce2b2b7d56,128'hfefe19e7d7d762b5ababe64d76769aec,128'hcaca458f82829d1fc9c940897d7d87fa,128'hfafa15ef5959ebb24747c98ef0f00bfb,128'hadadec41d4d467b3a2a2fd5fafafea45,128'h9c9cbf23a4a4f753727296e4c0c05b9b,128'hb7b7c275fdfd1ce19393ae3d26266a4c,128'h36365a6c3f3f417ef7f702f5cccc4f83,128'h34345c68a5a5f451e5e534d1f1f108f9,128'h717193e2d8d873ab3131536215153f2a,128'h04040c08c7c7529523236546c3c35e9d,128'h181828309696a13705050f0a9a9ab52f,128'h0707090e1212362480809b1be2e23ddf,128'hebeb26cd2727694eb2b2cd7f75759fea,128'h09091b1283839e1d2c2c74581a1a2e34,128'h1b1b2d366e6eb2dc5a5aeeb4a0a0fb5b,128'h5252f6a43b3b4d76d6d661b7b3b3ce7d,128'h29297b52e3e33edd2f2f715e84849713,128'h5353f5a6d1d168b900000000eded2cc1,128'h20206040fcfc1fe3b1b1c8795b5bedb6,128'h6a6abed4cbcb468dbebed96739394b72,128'h4a4ade944c4cd4985858e8b0cfcf4a85,128'hd0d06bbbefef2ac5aaaae54ffbfb16ed,128'h4343c5864d4dd79a3333556685859411,128'h4545cf8af9f910e9020206047f7f81fe,128'h5050f0a03c3c44789f9fba25a8a8e34b,128'h5151f3a2a3a3fe5d4040c0808f8f8a05,128'h9292ad3f9d9dbc2138384870f5f504f1,128'hbcbcdf63b6b6c177dada75af21216342,128'h10103020ffff1ae5f3f30efdd2d26dbf,128'hcdcd4c810c0c141813133526ecec2fc3,128'h5f5fe1be9797a2354444cc881717392e,128'hc4c45793a7a7f2557e7e82fc3d3d477a,128'h6464acc85d5de7ba19192b32737395e6,128'h6060a0c0818198194f4fd19edcdc7fa3,128'h222266442a2a7e549090ab3b8888830b,128'h4646ca8ceeee29c7b8b8d36b14143c28,128'hdede79a75e5ee2bc0b0b1d16dbdb76ad,128'he0e03bdb323256643a3a4e740a0a1e14,128'h4949db9206060a0c24246c485c5ce4b8,128'hc2c25d9fd3d36ebdacacef436262a6c4,128'h9191a8399595a431e4e437d379798bf2,128'he7e732d5c8c8438b3737596e6d6db7da,128'h8d8d8c01d5d564b14e4ed29ca9a9e049,128'h6c6cb4d85656faacf4f407f3eaea25cf,128'h6565afca7a7a8ef4aeaee94708081810,128'hbabad56f787888f025256f4a2e2e725c,128'h1c1c2438a6a6f157b4b4c773c6c65197,128'he8e823cbdddd7ca174749ce81f1f213e,128'h4b4bdd96bdbddc618b8b860d8a8a850f,128'h707090e03e3e427cb5b5c4716666aacc,128'h4848d89003030506f6f601f70e0e121c,128'h6161a3c235355f6a5757f9aeb9b9d069,128'h86869117c1c158991d1d273a9e9eb927,128'he1e138d9f8f813eb9898b32b11113322,128'h6969bbd2d9d970a98e8e89079494a733,128'h9b9bb62d1e1e223c87879215e9e920c9,128'hcece49875555ffaa28287850dfdf7aa5,128'h8c8c8f03a1a1f859898980090d0d171a,128'hbfbfda65e6e631d74242c6846868b8d0,128'h4141c3829999b0292d2d775a0f0f111e,128'hb0b0cb7b5454fca8bbbbd66d16163a2c};
   
   
localparam [15:0] wpoly = 16'b0000000100011011; //283 or 0x011b
localparam [127:0] test = {128'hc66363a5f87c7c84f87c7c84ee777799};

wire [127:0] s;
genvar i;

generate //allows s input to be identical to c code
    for(i=0; i<4; i = i+1)begin
        assign s[127 -(i*32)-: 32] = {s_in[487 -(i*32) -: 8],s_in[495 -(i*32) -: 8],s_in[503 -(i*32) -: 8],s_in[511 -(i*32) -: 8]  };
    end
endgenerate

reg [32:0] s_memory [15:0]; //for debugging

//quite sure xt and xt4 are no longer used at all
//function [7:0] xt;
//    input [7:0] v_in;
//    begin
//        xt = (((v_in) << 1) ^ ((((v_in) >> 7) & 1) * 8'h1b));
//    end
//endfunction

function [31:0] saes_b2w;
    input [31:0] b0;
    input [31:0] b1;
    input [31:0] b2;
    input [31:0] b3;
    begin
        saes_b2w = ((b3 <<24) | (b2 <<16) | (b1 <<8) | b0);
    end
endfunction

function saes_f2;
    input [31:0] x;
    begin
        saes_f2 = (x << 1) ^ ((( x >> 7 ) & 1'b1) * wpoly);
    end
endfunction

// saes_f3 is saes_f2(x) ^ x

function saes_u0;
    input [31:0]p;
    begin
        saes_u0 = saes_b2w(saes_f2(p),p,p,(saes_f2(p) ^p)); //last option is f3
    end
 endfunction
 
 function saes_u1;
    input [31:0]p;
    begin
        saes_u1 = saes_b2w((saes_f2(p) ^ p),saes_f2(p),p,p); //last option is f3
    end
 endfunction
 
 function saes_u2;
    input [31:0]p;
    begin
        saes_u2 = saes_b2w(p,(saes_f2(p)^p),saes_f2(p),p); //last option is f3
    end
 endfunction

 function saes_u3;
    input [31:0]p;
    begin
        saes_u3 = saes_b2w(p,p,(saes_f2(p)^p),saes_f2(p)); //last option is f3
    end
 endfunction

//it feels like saes_table is a static entity that can be pregenned using c then just set as a constant?
wire [8191:0] t[3:0];
wire [31:0] x0 = s[127-: 32];
wire [31:0] x1 = s[95-: 32];
wire [31:0] x2 = s[63-: 32];
wire [31:0] x3 = s[31-: 32];
wire [31:0] x0_a = x0 >> 8;
wire [31:0] x1_a = x1 >> 8;
wire [31:0] x2_a = x2 >> 8;
wire [31:0] x3_a = x3 >> 8;
wire [31:0] x0_b = x0 >> 16;
wire [31:0] x1_b = x1 >> 16;
wire [31:0] x2_b = x2 >> 16;
wire [31:0] x3_b = x3 >> 16;
wire [31:0] x0_c = x0 >> 24;
wire [31:0] x1_c = x1 >> 24;
wire [31:0] x2_c = x2 >> 24;
wire [31:0] x3_c = x3 >> 24;

assign t[0][8191:0] = saes[32767 -: 8192];
assign t[1]= saes[24575 -: 8192];
assign t[2] = saes[16383 -: 8192];
assign t[3][8191:0]= saes[8191 -: 8192]; //{128'h777799ee7b7b8df67b7b8df6f2f20dff,128'hf2f20dff6b6bbdd66b6bbdd66f6fb1de,128'h6f6fb1dec5c55491c5c5549130305060,128'h3030506001010302010103026767a9ce,128'h6767a9ce2b2b7d562b2b7d56fefe19e7,128'hfefe19e7d7d762b5d7d762b5ababe64d,128'hababe64d76769aec76769aeccaca458f,128'hcaca458f82829d1f82829d1fc9c94089,128'hc9c940897d7d87fa7d7d87fafafa15ef,128'hfafa15ef5959ebb25959ebb24747c98e,128'h4747c98ef0f00bfbf0f00bfbadadec41,128'hadadec41d4d467b3d4d467b3a2a2fd5f,128'ha2a2fd5fafafea45afafea459c9cbf23,128'h9c9cbf23a4a4f753a4a4f753727296e4,128'h727296e4c0c05b9bc0c05b9bb7b7c275,128'hb7b7c275fdfd1ce1fdfd1ce19393ae3d,128'h9393ae3d26266a4c26266a4c36365a6c,128'h36365a6c3f3f417e3f3f417ef7f702f5,128'hf7f702f5cccc4f83cccc4f8334345c68,128'h34345c68a5a5f451a5a5f451e5e534d1,128'he5e534d1f1f108f9f1f108f9717193e2,128'h717193e2d8d873abd8d873ab31315362,128'h3131536215153f2a15153f2a04040c08,128'h04040c08c7c75295c7c7529523236546,128'h23236546c3c35e9dc3c35e9d18182830,128'h181828309696a1379696a13705050f0a,128'h05050f0a9a9ab52f9a9ab52f0707090e,128'h0707090e121236241212362480809b1b,128'h80809b1be2e23ddfe2e23ddfebeb26cd,128'hebeb26cd2727694e2727694eb2b2cd7f,128'hb2b2cd7f75759fea75759fea09091b12,128'h09091b1283839e1d83839e1d2c2c7458,128'h2c2c74581a1a2e341a1a2e341b1b2d36,128'h1b1b2d366e6eb2dc6e6eb2dc5a5aeeb4,128'h5a5aeeb4a0a0fb5ba0a0fb5b5252f6a4,128'h5252f6a43b3b4d763b3b4d76d6d661b7,128'hd6d661b7b3b3ce7db3b3ce7d29297b52,128'h29297b52e3e33edde3e33edd2f2f715e,128'h2f2f715e84849713848497135353f5a6,128'h5353f5a6d1d168b9d1d168b900000000,128'h00000000eded2cc1eded2cc120206040,128'h20206040fcfc1fe3fcfc1fe3b1b1c879,128'hb1b1c8795b5bedb65b5bedb66a6abed4,128'h6a6abed4cbcb468dcbcb468dbebed967,128'hbebed96739394b7239394b724a4ade94,128'h4a4ade944c4cd4984c4cd4985858e8b0,128'h5858e8b0cfcf4a85cfcf4a85d0d06bbb,128'hd0d06bbbefef2ac5efef2ac5aaaae54f,128'haaaae54ffbfb16edfbfb16ed4343c586,128'h4343c5864d4dd79a4d4dd79a33335566,128'h3333556685859411858594114545cf8a,128'h4545cf8af9f910e9f9f910e902020604,128'h020206047f7f81fe7f7f81fe5050f0a0,128'h5050f0a03c3c44783c3c44789f9fba25,128'h9f9fba25a8a8e34ba8a8e34b5151f3a2,128'h5151f3a2a3a3fe5da3a3fe5d4040c080,128'h4040c0808f8f8a058f8f8a059292ad3f,128'h9292ad3f9d9dbc219d9dbc2138384870,128'h38384870f5f504f1f5f504f1bcbcdf63,128'hbcbcdf63b6b6c177b6b6c177dada75af,128'hdada75af212163422121634210103020,128'h10103020ffff1ae5ffff1ae5f3f30efd,128'hf3f30efdd2d26dbfd2d26dbfcdcd4c81,128'hcdcd4c810c0c14180c0c141813133526,128'h13133526ecec2fc3ecec2fc35f5fe1be,128'h5f5fe1be9797a2359797a2354444cc88,128'h4444cc881717392e1717392ec4c45793,128'hc4c45793a7a7f255a7a7f2557e7e82fc,128'h7e7e82fc3d3d477a3d3d477a6464acc8,128'h6464acc85d5de7ba5d5de7ba19192b32,128'h19192b32737395e6737395e66060a0c0,128'h6060a0c081819819818198194f4fd19e,128'h4f4fd19edcdc7fa3dcdc7fa322226644,128'h222266442a2a7e542a2a7e549090ab3b,128'h9090ab3b8888830b8888830b4646ca8c,128'h4646ca8ceeee29c7eeee29c7b8b8d36b,128'hb8b8d36b14143c2814143c28dede79a7,128'hdede79a75e5ee2bc5e5ee2bc0b0b1d16,128'h0b0b1d16dbdb76addbdb76ade0e03bdb,128'he0e03bdb32325664323256643a3a4e74,128'h3a3a4e740a0a1e140a0a1e144949db92,128'h4949db9206060a0c06060a0c24246c48,128'h24246c485c5ce4b85c5ce4b8c2c25d9f,128'hc2c25d9fd3d36ebdd3d36ebdacacef43,128'hacacef436262a6c46262a6c49191a839,128'h9191a8399595a4319595a431e4e437d3,128'he4e437d379798bf279798bf2e7e732d5,128'he7e732d5c8c8438bc8c8438b3737596e,128'h3737596e6d6db7da6d6db7da8d8d8c01,128'h8d8d8c01d5d564b1d5d564b14e4ed29c,128'h4e4ed29ca9a9e049a9a9e0496c6cb4d8,128'h6c6cb4d85656faac5656faacf4f407f3,128'hf4f407f3eaea25cfeaea25cf6565afca,128'h6565afca7a7a8ef47a7a8ef4aeaee947,128'haeaee9470808181008081810babad56f,128'hbabad56f787888f0787888f025256f4a,128'h25256f4a2e2e725c2e2e725c1c1c2438,128'h1c1c2438a6a6f157a6a6f157b4b4c773,128'hb4b4c773c6c65197c6c65197e8e823cb,128'he8e823cbdddd7ca1dddd7ca174749ce8,128'h74749ce81f1f213e1f1f213e4b4bdd96,128'h4b4bdd96bdbddc61bdbddc618b8b860d,128'h8b8b860d8a8a850f8a8a850f707090e0,128'h707090e03e3e427c3e3e427cb5b5c471,128'hb5b5c4716666aacc6666aacc4848d890,128'h4848d8900303050603030506f6f601f7,128'hf6f601f70e0e121c0e0e121c6161a3c2,128'h6161a3c235355f6a35355f6a5757f9ae,128'h5757f9aeb9b9d069b9b9d06986869117,128'h86869117c1c15899c1c158991d1d273a,128'h1d1d273a9e9eb9279e9eb927e1e138d9,128'he1e138d9f8f813ebf8f813eb9898b32b,128'h9898b32b11113322111133226969bbd2,128'h6969bbd2d9d970a9d9d970a98e8e8907,128'h8e8e89079494a7339494a7339b9bb62d,128'h9b9bb62d1e1e223c1e1e223c87879215,128'h87879215e9e920c9e9e920c9cece4987,128'hcece49875555ffaa5555ffaa28287850,128'h28287850dfdf7aa5dfdf7aa58c8c8f03,128'h8c8c8f03a1a1f859a1a1f85989898009,128'h898980090d0d171a0d0d171abfbfda65,128'hbfbfda65e6e631d7e6e631d74242c684,128'h4242c6846868b8d06868b8d04141c382,128'h4141c3829999b0299999b0292d2d775a,128'h2d2d775a0f0f111e0f0f111eb0b0cb7b,128'hb0b0cb7b5454fca85454fca8bbbbd66d,128'hbbbbd66d16163a2c16163a2c9d7b8175};
        
//genvar i,j;

//generate
//   for  (j =0; j<256; j = j +1) begin
//        assign t[0][8191 -(j*32) -: 32] = saes_u0(saes_data_default[2047 -(j*8) -: 8]);
//        assign t[1][8191 -(j*32) -: 32] = saes_u1(saes_data_default[2047 -(j*8) -: 8]);
//        assign t[2][8191 -(j*32) -: 32] = saes_u2(saes_data_default[2047 -(j*8) -: 8]);
//        assign t[3][8191 -(j*32) -: 32] = saes_u3(saes_data_default[2047 -(j*8) -: 8]);
        
        
//   end
//endgenerate

wire [31:0] y0 = t[0][8191-(32*(x0[7:0])) -: 32];// same as x0 & 0xff
wire [31:0] y1 = t[0][8191-(32*(x1[7:0])) -: 32];
wire [31:0] y2 = t[0][8191-(32*(x2[7:0])) -: 32];
wire [31:0] y3 = t[0][8191-(32*(x3[7:0])) -: 32];

wire [31:0] y0_a = y0 ^ t[1][8191-(32*(x1_a[7:0])) -: 32];// baked in t+256 to memory addresses
wire [31:0] y1_a = y1 ^ t[1][8191-(32*(x2_a[7:0])) -: 32];
wire [31:0] y2_a = y2 ^ t[1][8191-(32*(x3_a[7:0])) -: 32];
wire [31:0] y3_a = y3 ^ t[1][8191-(32*(x0_a[7:0])) -: 32];

wire [31:0] y0_b = y0_a ^ t[2][8191-(32*(x2_b[7:0])) -: 32];// same as x0 & 0xff
wire [31:0] y1_b = y1_a ^ t[2][8191-(32*(x3_b[7:0])) -: 32];
wire [31:0] y2_b = y2_a ^ t[2][8191-(32*(x0_b[7:0])) -: 32];
wire [31:0] y3_b = y3_a ^ t[2][8191-(32*(x1_b[7:0])) -: 32];

wire [31:0] y0_c = y0_b ^ t[3][8191-(32*(x3_c)) -: 32];// same as x0 & 0xff
wire [31:0] y1_c = y1_b ^ t[3][8191-(32*(x0_c)) -: 32];
wire [31:0] y2_c = y2_b ^ t[3][8191-(32*(x1_c)) -: 32];
wire [31:0] y3_c = y3_b ^ t[3][8191-(32*(x2_c)) -: 32];



assign s_out[127 -:32] = y0_c ^ rk[127 -: 32];
assign s_out[95 -:32] = y1_c ^ rk[95 -: 32];
assign s_out[63 -:32] = y2_c ^ rk[63 -: 32];
assign s_out[31 -:32] = y3_c ^ rk[31 -: 32];



//now generate output s 

endmodule




