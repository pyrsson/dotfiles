;; extends
(block_mapping_pair
  key: (flow_node [(double_quote_scalar) (single_quote_scalar)] @yamlkey))
(block_mapping_pair
  key: (flow_node (plain_scalar (string_scalar) @yamlkey)))

(flow_mapping
  (_ key: (flow_node [(double_quote_scalar) (single_quote_scalar)] @yamlkey)))
(flow_mapping
  (_ key: (flow_node (plain_scalar (string_scalar) @yamlkey))))
