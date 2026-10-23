# demo-side

The current main integration is healthy and exports only this product's own development files. The canonical CI selects captured tags, never product HEAD. Independent live tests and intentional historical lower-version fault fixtures are documented in [the coordinator live matrix](https://github.com/VOC-Experiments/ci-coordinator/blob/main/docs/live-validation.md).

The v1.3.0 tag was moved to this normal hook after the in-cascade arm failure/operator-rerun proof. The earlier fault commit6190adc and all its captures remain immutable evidence. Future cascades no longer deliberately fail their first attempt.
