<!-- latest_release 0.4.3 -->
## [v0.4.3](https://github.com/inspec/train-winrm/tree/v0.4.3) (2026-01-21)

#### Merged Pull Requests
- allow newer chef-winrm* gem versions [#61](https://github.com/inspec/train-winrm/pull/61) ([Stromweld](https://github.com/Stromweld))
<!-- latest_release -->

<!-- release_rollup since=0.4.0 -->
### Changes since 0.4.0 release

#### Merged Pull Requests
- allow newer chef-winrm* gem versions [#61](https://github.com/inspec/train-winrm/pull/61) ([Stromweld](https://github.com/Stromweld)) <!-- 0.4.3 -->
- remove stub block for latest mini-test compatibility [#62](https://github.com/inspec/train-winrm/pull/62) ([sathish-progress](https://github.com/sathish-progress)) <!-- 0.4.2 -->
- add GH copilot instructions [#56](https://github.com/inspec/train-winrm/pull/56) ([sathish-progress](https://github.com/sathish-progress)) <!-- 0.4.1 -->
<!-- release_rollup -->

<!-- latest_stable_release -->
## [v0.4.0](https://github.com/inspec/train-winrm/tree/v0.4.0) (2025-08-19)

#### New Features
- CHEF-20643, CHEF-21059, CHEF-21058, CHEF-23072 socks5h with kerberos support [#49](https://github.com/inspec/train-winrm/pull/49) ([sathish-progress](https://github.com/sathish-progress))

#### Merged Pull Requests
- Update to cookstyle [#46](https://github.com/inspec/train-winrm/pull/46) ([Vasu1105](https://github.com/Vasu1105))
- Upgrade to GitHub-native Dependabot [#30](https://github.com/inspec/train-winrm/pull/30) ([dependabot-preview[bot]](https://github.com/dependabot-preview[bot]))
- CHEF-21404 Enable CI for trufflelog scanning [#45](https://github.com/inspec/train-winrm/pull/45) ([Vasu1105](https://github.com/Vasu1105))
- CHEF-24678 - Remove standalone DCO file [#53](https://github.com/inspec/train-winrm/pull/53) ([nandanhegde73](https://github.com/nandanhegde73))
<!-- latest_stable_release -->

## [v0.3.1](https://github.com/inspec/train-winrm/tree/v0.3.1) (2025-06-10)

#### Merged Pull Requests
- Drop support for Ruby 3.0  [#42](https://github.com/inspec/train-winrm/pull/42) ([Nik08](https://github.com/Nik08))
- Manually bump minor version in train-winrm [#44](https://github.com/inspec/train-winrm/pull/44) ([Nik08](https://github.com/Nik08))
- [DO NOT MERGE] CHEF-19302 Ruby 3.4 upgrade [#40](https://github.com/inspec/train-winrm/pull/40) ([Vasu1105](https://github.com/Vasu1105))

## [v0.2.19](https://github.com/inspec/train-winrm/tree/v0.2.19) (2025-04-30)

#### Merged Pull Requests
- Update sonar scanner version [#41](https://github.com/inspec/train-winrm/pull/41) ([Vasu1105](https://github.com/Vasu1105))
- Dependencies version pinning changes [#43](https://github.com/inspec/train-winrm/pull/43) ([Nik08](https://github.com/Nik08))

## [v0.2.17](https://github.com/inspec/train-winrm/tree/v0.2.17) (2025-02-10)

#### Merged Pull Requests
- Fix the verify pipeline failng with cannot load such file -- mocha/setup (LoadError) [#37](https://github.com/inspec/train-winrm/pull/37) ([Vasu1105](https://github.com/Vasu1105))
- Remove ruby 2.5 and 2.6 test  [#38](https://github.com/inspec/train-winrm/pull/38) ([Vasu1105](https://github.com/Vasu1105))
- CHEF-7501: Configures sonarqube for code coverage analysis [#36](https://github.com/inspec/train-winrm/pull/36) ([Vasu1105](https://github.com/Vasu1105))
- Updating for rexml cve inclusion [#39](https://github.com/inspec/train-winrm/pull/39) ([johnmccrae](https://github.com/johnmccrae))

## [v0.2.13](https://github.com/inspec/train-winrm/tree/v0.2.13) (2022-02-25)

#### Merged Pull Requests
- CFINSPEC-2 Added options to allow SSL connection with certificates [#34](https://github.com/inspec/train-winrm/pull/34) ([Nik08](https://github.com/Nik08))

## [v0.2.12](https://github.com/inspec/train-winrm/tree/v0.2.12) (2021-01-29)

#### Merged Pull Requests
- Use latest winrm for ruby 3 support [#29](https://github.com/inspec/train-winrm/pull/29) ([clintoncwolfe](https://github.com/clintoncwolfe))

## [v0.2.11](https://github.com/inspec/train-winrm/tree/v0.2.11) (2020-09-30)

#### Merged Pull Requests
- Remove redundant encoding comments [#22](https://github.com/inspec/train-winrm/pull/22) ([tas50](https://github.com/tas50))
- Add winrm-shell-type option and winrm elevated shell [#25](https://github.com/inspec/train-winrm/pull/25) ([catriona1](https://github.com/catriona1))
- Add validation to winrm shell type option [#28](https://github.com/inspec/train-winrm/pull/28) ([catriona1](https://github.com/catriona1))
- Allow timeout option for WinRM commands [#27](https://github.com/inspec/train-winrm/pull/27) ([james-stocks](https://github.com/james-stocks))
- Correct minor spelling mistakes [#23](https://github.com/inspec/train-winrm/pull/23) ([tas50](https://github.com/tas50))

## [v0.2.6](https://github.com/inspec/train-winrm/tree/v0.2.6) (2019-12-31)

#### Merged Pull Requests
- Substitute require for require_relative [#21](https://github.com/inspec/train-winrm/pull/21) ([tas50](https://github.com/tas50))

## [v0.2.5](https://github.com/inspec/train-winrm/tree/v0.2.5) (2019-09-25)

#### Bug Fixes
- Fixes for NameError: uninitialized constant TrainPlugins::WinRM::FS [#18](https://github.com/inspec/train-winrm/pull/18) ([vsingh-msys](https://github.com/vsingh-msys))

## [v0.2.4](https://github.com/inspec/train-winrm/tree/v0.2.4) (2019-09-04)

#### Merged Pull Requests
- Limit the files we ship in the gem but include the LICENSE file [#14](https://github.com/inspec/train-winrm/pull/14) ([tas50](https://github.com/tas50))

## [v0.2.3](https://github.com/inspec/train-winrm/tree/v0.2.3) (2019-08-12)

#### Enhancements
- Update expeditor config to publish rubygems on promote [#11](https://github.com/inspec/train-winrm/pull/11) ([clintoncwolfe](https://github.com/clintoncwolfe))

#### Merged Pull Requests
- Update README [#3](https://github.com/inspec/train-winrm/pull/3) ([clintoncwolfe](https://github.com/clintoncwolfe))
- Add expeditor and buildkite verify pipeline [#6](https://github.com/inspec/train-winrm/pull/6) ([miah](https://github.com/miah))
- Apply Chefstyle to train-winrm [#5](https://github.com/inspec/train-winrm/pull/5) ([miah](https://github.com/miah))
- Fix PR 2 [#7](https://github.com/inspec/train-winrm/pull/7) ([zenspider](https://github.com/zenspider))
- Update pin on train to v3 [#9](https://github.com/inspec/train-winrm/pull/9) ([clintoncwolfe](https://github.com/clintoncwolfe))
- Depend on train-core via the Gemfile, not train [#12](https://github.com/inspec/train-winrm/pull/12) ([clintoncwolfe](https://github.com/clintoncwolfe))