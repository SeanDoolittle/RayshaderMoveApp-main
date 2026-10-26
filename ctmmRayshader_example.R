source("data/auxiliary/local-files/provided-app-files/ctmmRayshader.r")


df=read.csv("data/auxiliary/local-files/provided-app-files/movebank_data/Movement patterns of seed dispersing spotted nutcrackers (Nucifraga caryocatactes).csv")

unique(df$individual.local.identifier)
part_1_stuff=part_1(individuals=c("K94648","K125874"),
                    df=df,
                    padding=.05,
                    season="all",
                    shadow_intesity=.3,
                    stretch=c(.005,995)
)

plot_rayshader(individuals=c("K94648","K125874"),
               df=df,
               sim_path=FALSE,
               AKDE=TRUE,
               AKDE_color_list = c("Reds 3","Blues 2"),
               show_data = TRUE,
               padding =.05,
               animate_shadows=FALSE,
               spin_animation=FALSE, 
               season="all",
               shadow_intesity=.3,
               stretch=c(.005,995),
               part_1_stuff=part_1_stuff,
               animation_duration = 0)


num_frames=900
angles= seq(0,360,length.out = num_frames)[-1]
j=1
for(i in 1:num_frames) {
  
  render_camera(theta=angles[num_frames-i])
  render_snapshot(filename = sprintf("data/auxiliary/local-files/provided-app-files/animation/landsat_hillshade%i.png", j))  
  j=j+1
  
}
close3d()
av::av_encode_video(sprintf("data/auxiliary/local-files/provided-app-files/animation/landsat_hillshade%d.png",seq(1,num_frames,by=1)), framerate = 30,
                    output = "www/Rayshader_spin_animation.mp4")
system("ffmpeg -framerate 30 -i data/auxiliary/local-files/provided-app-files/animation/landsat_hillshade%d.png -pix_fmt yuv420p Rayshader_spin_animation.mp4")






# load("fit_models/K125854.rda")
# FIT_K125854=FIT
# load("fit_models/Bat2_3D6001852B95D.rda")
# FIT_Bat2=FIT

df=read.csv("data/auxiliary/local-files/provided-app-files/movebank_data/3D flights of European free-tailed bats.csv")
#df=read.csv("data/auxiliary/local-files/provided-app-files/movebank_data/Movement patterns of seed dispersing spotted nutcrackers (Nucifraga caryocatactes).csv")

part_1_stuff=part_1(individuals=c("Bat2_3D6001852B95D"),
                    df=df,
                    padding=.03,
                   #FIT_list=c(FIT_Bat2),
                    season="all",
                    shadow_intesity=.5,
                    stretch=c(.005,995)
)

plot_rayshader(individuals=c("36827","36831","36840","36935","36999","37009","37010"),
               df=df,
               #FIT_list=c(FIT_K125854,FIT_K125874),
               sim_path=FALSE,
               AKDE=FALSE,
               AKDE_color_list = c("Purp","Reds 2","Reds 3","Blues 2", "Blues 3", "Greens 2","Greens 3"),
               show_data = TRUE,
               padding =.03,
               animate_shadows=FALSE,
               spin_animation=FALSE, 
               season="all",
               shadow_intesity=.3,
               stretch=c(.005,995),
               part_1_stuff=part_1_stuff,
               animation_duration = 0)






# hillshade=make_hillshade(landsat_rgb_cropped=part_1_stuff$landsat,
#                elevation_cropped=part_1_stuff$elvation,
#                akde_list=part_1_stuff$akde_list,
#                combined_CI=part_1_stuff$combined_CI,
#                AKDE_color_list=c("Reds 3", "Blues 3"),
#                AKDE=TRUE,
#                sunangle=50,
#                shadow_intesity=.3,
#                stretch=c(.005,.995))


# tiff_image <- brick("landsat_with_overlay.tiff")
# plotRGB(tiff_image)



plot_rayshader(individuals=c("Bat2_3D6001852B95D"),
               df=df,
               #FIT_list=c(FIT_K125854,FIT_K125874),
               sim_path=TRUE,
               AKDE=TRUE,
               AKDE_color_list = c("Purp"),
               show_data = FALSE,
               padding =.03,
               animate_shadows=FALSE,
               spin_animation=TRUE, 
               season="all",
               shadow_intesity=.5,
               stretch=c(.005,995),
               part_1_stuff=part_1_stuff,
               animation_duration = 10)



# df=read.csv("data/auxiliary/local-files/provided-app-files/movebank_data/3D flights of European free-tailed bats.csv")
# DATA=as.telemetry(df[df$individual.local.identifier=="Bat2_3D6001852B95D",])
# 
# GUESS <- ctmm.guess(DATA,interactive=FALSE)
# FIT <- ctmm.select(DATA,GUESS,trace=3)
# FIT$
# 
# a=difftime(DATA$timestamp[2],DATA$timestamp[1],"sec")
# b=dimub=dimeanb=difftime(DATA$timestamp[3],DATA$timestamp[2],"sec")
# delta_time=c(a,b)
# avg_delta_time=mean(delta_time) 
# as.numeric(avg_delta_time)
# 
# 
# df=read.csv("data/auxiliary/local-files/provided-app-files/movebank_data/Movement patterns of seed dispersing spotted nutcrackers (Nucifraga caryocatactes).csv")
# DATA=as.telemetry(df[df$individual.local.identifier=="K125907",])
# GUESS <- ctmm.guess(DATA,interactive=FALSE)
# FIT <- ctmm.select(DATA,GUESS,trace=3)
# speed(FIT)




# load("fit_models/3_mogambo.rda")
# FIT_mogambo=FIT

# df=read.csv("movebank_data/Hornbill telemetry in northeast India.csv")
# 
# unique(df$individual.local.identifier)
# 
# plot_rayshader(individuals=c("3_mogambo"),
#                df=df,
#                #FIT_list=c(FIT_mogambo),
#                sim_path=TRUE,
#                AKDE=FALSE,
#                AKDE_color_list = c("Purples 3"),
#                show_data = FALSE,
#                padding =-.07,
#                animate_shadows=FALSE,
#                spin_animation=FALSE,
#                sim_animation=TRUE,
#                season="all",
#                shadow_intesity=.3,
#                stretch=c(.005,995))



