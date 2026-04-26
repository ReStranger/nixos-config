_: {
  nixpkgs.overlays = [
    (final: prev: {
      python3Packages = prev.python3Packages.overrideScope (
        self: super: {
          aioboto3 = super.aioboto3.overridePythonAttrs (old: {
            disabledTests = (old.disabledTests or [ ]) ++ [
              "test_dynamo_resource_query"
              "test_dynamo_resource_put"
              "test_dynamo_resource_batch_write_flush_on_exit_context"
              "test_dynamo_resource_batch_write_flush_amount"
              "test_flush_doesnt_reset_item_buffer"
              "test_dynamo_resource_property"
              "test_dynamo_resource_waiter"
            ];
          });
        }
      );
    })
  ];
}
