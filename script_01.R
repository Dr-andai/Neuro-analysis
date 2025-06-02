# install package
library(NeuroDecodeR)

# In order to use the NeuroDecodeR package, neural data must be put into a particular format called “raster format.
raster_dir_name <- "data"

# reading site 21
raster_data <- read_raster_data(file.path(raster_dir_name,'raster_data_bert_am_site021.rda'))

plot(raster_data)

binned_file_name <- create_binned_data(raster_dir_name,
                                       save_prefix_name = "FV_AM",
                                       bin_width = 30,
                                       sampling_interval = 10)


label_info <- get_num_label_repetitions(binned_file_name,
                                        labels = "orient_person_combo")

plot(label_info, show_legend=FALSE)

sites_to_use <- get_siteIDs_with_k_label_repetitions(
  "FV_AM_30bins_10sampled.Rda",
  labels = "orient_person_combo",
  k= 3)

plot(sites_to_use)

## let's use right labels instead of left
rigt_profile_levels <- paste("right profile", 1:25)

######
ds <- ds_basic(binned_data = "FV_AM_30bins_10sampled.Rda",
               labels = "orient_person_combo",
               num_cv_splits = 3,
               label_levels = rigt_profile_levels,
               site_IDs_to_use = sites_to_use)

fps <- list(fp_zscore())

cl <- cl_max_correlation()

rms <- list(rm_main_results(), rm_confusion_matrix())

# pipeline
cv <- cv_standard(datasource = ds,
                  classifier = cl,
                  feature_preprocessors = fps,
                  result_metrics = rms)


DECODING_RESULTS <- run_decoding(cv)

plot(DECODING_RESULTS$rm_main_results,
     type = "line",
     results_to_show = "all")

plot(DECODING_RESULTS$rm_confusion_matrix,
     plot_only_one_train_time = 206)

log_save_results(DECODING_RESULTS,
                 save_directory_name = "results",
                 result_name = "Right profile face decoding")




