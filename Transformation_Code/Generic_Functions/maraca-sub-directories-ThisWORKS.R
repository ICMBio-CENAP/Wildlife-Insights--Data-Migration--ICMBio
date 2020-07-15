# For some Maraca camera traps, images are in several sub-directories
# this script identifies them and changes the image Location in the images file 

## First create a dataframe with the new locations:

# CT-EEM-1-7
list.files("C:/Users/ICMBio/Desktop/Maraca/CT-EEM-1-7")

a <- tibble(path = list.files("C:/Users/ICMBio/Desktop/Maraca/CT-EEM-1-7/100EK113", full.names = TRUE))
b <- tibble(path = list.files("C:/Users/ICMBio/Desktop/Maraca/CT-EEM-1-7/101EK113", full.names = TRUE))
c <- tibble(path = list.files("C:/Users/ICMBio/Desktop/Maraca/CT-EEM-1-7/102EK113", full.names = TRUE))
d <- tibble(path = list.files("C:/Users/ICMBio/Desktop/Maraca/CT-EEM-1-7/103EK113", full.names = TRUE))
e <- tibble(path = list.files("C:/Users/ICMBio/Desktop/Maraca/CT-EEM-1-7/104EK113", full.names = TRUE))
f <- tibble(path = list.files("C:/Users/ICMBio/Desktop/Maraca/CT-EEM-1-7/105EK113", full.names = TRUE))
g <- tibble(path = list.files("C:/Users/ICMBio/Desktop/Maraca/CT-EEM-1-7/106EK113", full.names = TRUE))
h <- tibble(path = list.files("C:/Users/ICMBio/Desktop/Maraca/CT-EEM-1-7/107EK113", full.names = TRUE))
i <- tibble(path = list.files("C:/Users/ICMBio/Desktop/Maraca/CT-EEM-1-7/108EK113", full.names = TRUE))

cam1.7 <- bind_rows(a,b,c,d,e,f,g,h,i)
cam <- gsub("C:/Users/ICMBio/Desktop/Maraca/","",cam1.7$path)

Dep.ID <- substr(cam, 1,10)

ct.eem.1.7 <- cbind(cam, Dep.ID); colnames(ct.eem.1.7) <- c("path", "Deployment.ID")
ct.eem.1.7 <- data.frame(ct.eem.1.7)
ct.eem.1.7$path <- as.character(ct.eem.1.7$path)
ct.eem.1.7$Deployment.ID <- as.character(ct.eem.1.7$Deployment.ID)
ct.eem.1.7$Image.ID <- substr(ct.eem.1.7$path, 21,nchar(ct.eem.1.7$path))
head(ct.eem.1.7)



#-----------------------
# CT-EEM-1-10
list.files("C:/Users/ICMBio/Desktop/Maraca/CT-EEM-1-10")
a <- tibble(path = list.files("C:/Users/ICMBio/Desktop/Maraca/CT-EEM-1-10/100EK113", full.names = TRUE))
b <- tibble(path = list.files("C:/Users/ICMBio/Desktop/Maraca/CT-EEM-1-10/101EK113", full.names = TRUE))
c <- tibble(path = list.files("C:/Users/ICMBio/Desktop/Maraca/CT-EEM-1-10/102EK113", full.names = TRUE))
d <- tibble(path = list.files("C:/Users/ICMBio/Desktop/Maraca/CT-EEM-1-10/103EK113", full.names = TRUE))
cam1.10 <- bind_rows(a,b,c,d)
cam <- gsub("C:/Users/ICMBio/Desktop/Maraca/","",cam1.10$path)
Dep.ID <- substr(cam, 1,11)
ct.eem.1.10 <- cbind(cam, Dep.ID); colnames(ct.eem.1.10) <- c("path", "Deployment.ID")
ct.eem.1.10 <- data.frame(ct.eem.1.10)
ct.eem.1.10$path <- as.character(ct.eem.1.10$path)
ct.eem.1.10$Deployment.ID <- as.character(ct.eem.1.10$Deployment.ID)
ct.eem.1.10$Image.ID <- substr(ct.eem.1.10$path, 22,nchar(ct.eem.1.10$path))
head(ct.eem.1.10)


#-----------------------
# CT-EEM-1-16
list.files("C:/Users/ICMBio/Desktop/Maraca/CT-EEM-1-16")
a <- tibble(path = list.files("C:/Users/ICMBio/Desktop/Maraca/CT-EEM-1-16/100EK113", full.names = TRUE))
b <- tibble(path = list.files("C:/Users/ICMBio/Desktop/Maraca/CT-EEM-1-16/101EK113", full.names = TRUE))
c <- tibble(path = list.files("C:/Users/ICMBio/Desktop/Maraca/CT-EEM-1-16/102EK113", full.names = TRUE))
d <- tibble(path = list.files("C:/Users/ICMBio/Desktop/Maraca/CT-EEM-1-16/103EK113", full.names = TRUE))
e <- tibble(path = list.files("C:/Users/ICMBio/Desktop/Maraca/CT-EEM-1-16/104EK113", full.names = TRUE))
f <- tibble(path = list.files("C:/Users/ICMBio/Desktop/Maraca/CT-EEM-1-16/105EK113", full.names = TRUE))
g <- tibble(path = list.files("C:/Users/ICMBio/Desktop/Maraca/CT-EEM-1-16/106EK113", full.names = TRUE))
h <- tibble(path = list.files("C:/Users/ICMBio/Desktop/Maraca/CT-EEM-1-16/107EK113", full.names = TRUE))
i <- tibble(path = list.files("C:/Users/ICMBio/Desktop/Maraca/CT-EEM-1-16/108EK113", full.names = TRUE))
j <- tibble(path = list.files("C:/Users/ICMBio/Desktop/Maraca/CT-EEM-1-16/109EK113", full.names = TRUE))
k <- tibble(path = list.files("C:/Users/ICMBio/Desktop/Maraca/CT-EEM-1-16/110EK113", full.names = TRUE))
l <- tibble(path = list.files("C:/Users/ICMBio/Desktop/Maraca/CT-EEM-1-16/111EK113", full.names = TRUE))
m <- tibble(path = list.files("C:/Users/ICMBio/Desktop/Maraca/CT-EEM-1-16/112EK113", full.names = TRUE))

cam1.16 <- bind_rows(a,b,c,d,e,f,g,h,i,j,k,l,m)
cam <- gsub("C:/Users/ICMBio/Desktop/Maraca/","",cam1.16$path)
Dep.ID <- substr(cam, 1,11)
ct.eem.1.16 <- cbind(cam, Dep.ID); colnames(ct.eem.1.16) <- c("path", "Deployment.ID")
ct.eem.1.16 <- data.frame(ct.eem.1.16)
ct.eem.1.16$path <- as.character(ct.eem.1.16$path)
ct.eem.1.16$Deployment.ID <- as.character(ct.eem.1.16$Deployment.ID)
ct.eem.1.16$Image.ID <- substr(ct.eem.1.16$path, 22,nchar(ct.eem.1.16$path))
head(ct.eem.1.16)
#dim(ct.eem.1.16)
#dim(subset(images, Deployment.ID=="CT-EEM-1-16"))


#-----------------------
# CT-EEM-1-21
list.files("C:/Users/ICMBio/Desktop/Maraca/CT-EEM-1-21")
a <- tibble(path = list.files("C:/Users/ICMBio/Desktop/Maraca/CT-EEM-1-21/100EK113", full.names = TRUE))
b <- tibble(path = list.files("C:/Users/ICMBio/Desktop/Maraca/CT-EEM-1-21/101EK113", full.names = TRUE))

cam1.21 <- bind_rows(a,b)
cam <- gsub("C:/Users/ICMBio/Desktop/Maraca/","",cam1.21$path)
Dep.ID <- substr(cam, 1,11)
ct.eem.1.21 <- cbind(cam, Dep.ID); colnames(ct.eem.1.21) <- c("path", "Deployment.ID")
ct.eem.1.21 <- data.frame(ct.eem.1.21)
ct.eem.1.21$path <- as.character(ct.eem.1.21$path)
ct.eem.1.21$Deployment.ID <- as.character(ct.eem.1.21$Deployment.ID)
ct.eem.1.21$Image.ID <- substr(ct.eem.1.21$path, 22,nchar(ct.eem.1.21$path))
head(ct.eem.1.21)
dim(ct.eem.1.21)
dim(subset(images, Deployment.ID=="CT-EEM-1-21"))

#-------------------------------------------------------

library(stringr)
images$join_field <- as.character(str_sub(images$Deployment.ID, end=-12))
images$path <- NA

images$path[which(images$join_field == "CT-EEM-1-7")] <- ct.eem.1.7$path
images$path[which(images$join_field == "CT-EEM-1-10")] <- ct.eem.1.10$path
images$path[which(images$join_field == "CT-EEM-1-16")] <- ct.eem.1.16$path
images$path[which(images$join_field == "CT-EEM-1-21")] <- ct.eem.1.21$path

#View(images)
images$Location <- as.character(images$Location)

for(i in 1:nrow(images)) {
  if(is.na(images$path[i]) == FALSE) {
    images$Location[i] <- images$path[i]
  }
  else{}
}

images <- images[,-c(17,18)]

# save modified "images"
write.csv(images, here("Datasets", "maraca", "maraca_2018_images_fix.csv"), row.names = FALSE)
