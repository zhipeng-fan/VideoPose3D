#!/bin/bash
source ~/anaconda3/etc/profile.d/conda.sh

# echo "Jumping to the Detectron repo..."
# cd ../../detectron/

# echo "Activate environment for Detectron..."
# conda activate py27

# mkdir tmp_output
# echo "Inference 2D key points on videos..."
# python tools/infer_video.py \
#     --cfg configs/12_2017_baselines/e2e_keypoint_rcnn_R-101-FPN_s1x.yaml \
#     --output-dir tmp_output \
#     --image-ext avi \
# 	--wts https://dl.fbaipublicfiles.com/detectron/37698009/12_2017_baselines/e2e_keypoint_rcnn_R-101-FPN_s1x.yaml.08_45_57.YkrJgP6O/output/train/keypoints_coco_2014_train:keypoints_coco_2014_valminusminival/generalized_rcnn/model_final.pkl \
#     videos

# echo "Moving 2D detections to VideoPose3D folder..."
# mv tmp_output /home/videolab/Documents/3D_pose_estimation/VideoPose3D/

# cd /home/videolab/Documents/3D_pose_estimation/VideoPose3D/
# echo "Activate environment for pose estimation..."
# conda deactivate
conda activate py37

# echo "Creating custom dataset..."
# cd data
# python prepare_data_2d_custom.py -i ../tmp_output -o exercise
# cd ..

echo "Estimate the 3D pose..."
mkdir results
IFS="/"
for file in tmp_output/*.npz; do 
    read -ra ADDR <<< "$file"
    python run.py -d custom -k exercise -arc 3,3,3,3,3\
          -c checkpoint --evaluate pretrained_h36m_detectron_coco.bin \
          --render --viz-subject ${ADDR[-1]::-4} --viz-action custom --viz-camera 0 --viz-video ../../detectron/videos/${ADDR[-1]::-4} --viz-output ./results/${ADDR[-1]::-8}_camera_all.mp4 --viz-size 6
#     python run.py -d custom -k exercise -arc 3,3,3,3,3\
#           -c checkpoint --evaluate pretrained_h36m_detectron_coco.bin \
#           --render --viz-subject ${ADDR[-1]::-4} --viz-action custom --viz-camera 0 --viz-video ../../detectron/videos/${ADDR[-1]::-4} --viz-output ./results/${ADDR[-1]::-8}_camera_frontside.mp4 --viz-size 6 --azimuth=45
#     python run.py -d custom -k exercise -arc 3,3,3,3,3\
#           -c checkpoint --evaluate pretrained_h36m_detectron_coco.bin \
#           --render --viz-subject ${ADDR[-1]::-4} --viz-action custom --viz-camera 0 --viz-video ../../detectron/videos/${ADDR[-1]::-4} --viz-output ./results/${ADDR[-1]::-8}_camera_side.mp4 --viz-size 6 --azimuth=90
done

echo "Cleaning..."
# rm -rf ./tmp_output

echo "Finished!"