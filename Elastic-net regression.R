# Load required packages
require(glmnet)
require(Matrix)
require(openxlsx)

# -----------------------------
# Data Import
# -----------------------------
# Replace "data/nb.csv" with your local file path
data <- read.table("data/xx.csv", header = TRUE, sep = ",") 

# Remove missing values
data <- na.omit(data)
cat("Number of missing values:", sum(is.na(data)), "\n")

# Separate predictors and response
X <- as.matrix(data[, -41])
y <- data[, 41]

# -----------------------------
# Elastic Net Cross-Validation
# -----------------------------
alpha_range <- seq(0.05, 1, length.out = 20)  # Range of alpha values
results <- list()  # Store CV results

for (alpha in alpha_range) {
  cv_model <- cv.glmnet(X, y, alpha = alpha, nfolds = 10)
  results[[as.character(alpha)]] <- cv_model
}

# Print CV results for each alpha
for (alpha in alpha_range) {
  model <- results[[as.character(alpha)]]
  cat("Alpha:", alpha, "\n")
  print(model)
  cat("\n")
}

# -----------------------------
# Identify Best Model by Minimum MSE
# -----------------------------
min_mse <- Inf
best_alpha <- NULL

for (alpha in alpha_range) {
  model <- results[[as.character(alpha)]]
  if (min(model$cvm) < min_mse) {
    min_mse <- min(model$cvm)
    best_alpha <- alpha
  }
}

cat("Best alpha with minimum MSE:", best_alpha, "\n")
cat("Minimum MSE:", min_mse, "\n")

best_model <- results[[as.character(best_alpha)]]

cat("Best alpha:", best_alpha, "\n")
cat("Lambda for minimum MSE:", best_model$lambda.min, "\n")
cat("Lambda for 1 standard error:", best_model$lambda.1se, "\n\n")

# Coefficients
cat("Coefficients for minimum MSE model:\n")
print(coef(best_model, s = best_model$lambda.min))
cat("\n")

cat("Coefficients for 1 standard error model:\n")
print(coef(best_model, s = best_model$lambda.1se))
cat("\n")

# -----------------------------
# Fit Elastic Net with specific alpha/lambda (example)
# -----------------------------
elasticnet_model <- glmnet(X, y, alpha = 1, lambda = 0.9963375)
print(elasticnet_model$beta)

# -----------------------------
# Prediction
# -----------------------------
predictions <- predict(elasticnet_model, newx = X, s = c(1, 0.9963375))
correlation <- cor(predictions, y)
cat("Correlation between predicted y and true y:", correlation, "\n")

# -----------------------------
# Permutation Test
# -----------------------------
num_permutations <- 5000
correlations <- numeric(num_permutations)

for (i in 1:num_permutations) {
  permuted_X <- X[sample(nrow(X)), ]
  sparse_X <- Matrix(permuted_X, sparse = TRUE)
  
  perm_model <- glmnet(sparse_X, y, alpha = 0.1, lambda = 0.5892858)
  predicted_y <- predict(perm_model, newx = sparse_X, s = 0.5892858)
  
  correlations[i] <- cor(predicted_y, y)
}

print(correlations)

# Save permutation results to TXT
write.table(correlations, file = "bartbev2.txt", col.names = FALSE)

# -----------------------------
# Save to Excel
# -----------------------------
correlations_df <- data.frame(Correlation = correlations)
write.xlsx(correlations_df, file = "bartbev2REWARD.xlsx",
           sheetName = "Correlation Results", colNames = FALSE)

# -----------------------------
# Clear workspace
# -----------------------------
rm(list = ls())