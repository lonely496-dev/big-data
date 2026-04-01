# Data

## Source

The dataset (`cdc.csv`) is a subset of the **Behavioral Risk Factor Surveillance System (BRFSS)**, collected by the CDC via random-digit dialing telephone surveys.

Place your copy of `cdc.csv` in this directory before running the pipeline.

## Variables Used

| Variable   | Type        | Values                                 | Description                        |
| ---------- | ----------- | -------------------------------------- | ---------------------------------- |
| `genhlth`  | Ordinal     | excellent, very good, good, fair, poor | Self-rated general health status   |
| `exerany`  | Binary      | 0 = No_Exercise, 1 = Yes_Exercise      | Exercise in the past month         |
| `hlthplan` | Binary      | 0 = No_Plan, 1 = Yes_Plan              | Has health plan coverage           |
| `smoke100` | Binary      | 0 = No_Smoke, 1 = Yes_Smoke            | Smoked 100+ cigarettes in lifetime |
| `gender`   | Categorical | m, f                                   | Respondent gender                  |

## Variables Excluded

Continuous variables (age, height, weight, wtdesire, wtlbs) were excluded because correspondence analysis operates on frequency tables of categorical variables only.

## Notes

- Rows with missing values (`NA`) are removed during preprocessing.
