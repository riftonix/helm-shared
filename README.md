# Helm charts

This repository contains independently versioned Helm components under
[`charts/`](charts) and [`libs/`](libs). Each direct child directory with a `Chart.yaml` is
published and updated independently, with its own Updatecli pipeline and PR.
The directory group does not determine merge priority.

[`charts/appchart`](charts/appchart) is a universal application chart that consumes
reusable components from `libs/`. `libs/common` is a Helm library chart; most other
components under `libs/` are application charts for rendering custom resources.

`appchart` and its reusable components originate from the
[NXS Universal Chart family](https://github.com/nixys/nxs-universal-chart).

See [Independent upstream chart updates](updatecli/README.md) for per-component
OCI pins, fork policy, and the Updatecli pull-request workflow. Dependencies are
merged and published first when necessary; merge order is determined manually.
