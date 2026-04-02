## Configuring the Pattern

Each fab4c pattern supports a variety of features and options, depending on the pattern
type that allow you to customize the scale and behaviour of the resources provisioned. The important things to remember are;

- If it's to improve security or performance it will be enabled by default and there's no need to customize
- New features that are disruptive will be diabled by default so that you can decide when you want to enable them.
- Where possible, options and features will have defaults set for you based on recommended defaults from AWS or best practice.
- The internal defaults that are set are intended for Enterprise use. If you are concerned about potential costs, review the output of `terraform plan` before provisioning


### Pattern Features



#### custom_iam_role_policy

:::feature Feature Information

<div className="features-table">

|   |   |
|---|---|
| Description    | A custom IAM policy that should be attached to the permissions allocated to the 3rd Party |
| Out of the box?    | <span className="badge-ff badge-ff-is-disabled">**Disabled**</span>   |
| Service Impacting?    | <span className="badge-ff badge-ff-not-disruptive">**Non-Disruptive**</span>   |


</div>

:::


##### Additional Feature Settings



-  `content`

  <div className="options-table">

  |   |   |
  |---|---|
  | Setting is?     | Optional |
  | Default value | See below for default <i className="fa-solid fa-arrow-down"></i> |

  </div>

    ```
    {}
    ```




<div className="pattern-feature-spacer" />



#### iam_role_policy_attachments

:::feature Feature Information

<div className="features-table">

|   |   |
|---|---|
| Description    | A list of existing IAM policies in the account that should be attachd to the 3rd Party role created. |
| Out of the box?    | <span className="badge-ff badge-ff-is-disabled">**Disabled**</span>   |
| Service Impacting?    | <span className="badge-ff badge-ff-not-disruptive">**Non-Disruptive**</span>   |


</div>

:::


##### Additional Feature Settings



-  `arns`

  <div className="options-table">

  |   |   |
  |---|---|
  | Setting is?     | Optional |
  | Default value | `['arn:aws:iam::aws:policy/job-function/ViewOnlyAccess']` |

  </div>




<div className="pattern-feature-spacer" />



### Pattern Options



- `third_party_aws_account_id`

  <div className="options-table">

  |   |   |
  |---|---|
  | Setting is?     | Required |
  | Example value | `123456789123` |

  </div>




- `third_party_secret`

  <div className="options-table">

  |   |   |
  |---|---|
  | Setting is?     | Optional |
  | Default value | `None` |

  </div>





- `third_party_ipal`

  <div className="options-table">

  |   |   |
  |---|---|
  | Setting is?     | Optional |
  | Default value | `None` |

  </div>





- `service_provider_requires_mfa`

  <div className="options-table">

  |   |   |
  |---|---|
  | Setting is?     | Optional |
  | Default value | `False` |

  </div>





- `max_session_duration`

  <div className="options-table">

  |   |   |
  |---|---|
  | Setting is?     | Optional |
  | Default value | `3600` |

  </div>





- `third_party_aws_arns`

  <div className="options-table">

  |   |   |
  |---|---|
  | Setting is?     | Required |
  | Example value | `['external-ARN', 'external-ARN']` |

  </div>




