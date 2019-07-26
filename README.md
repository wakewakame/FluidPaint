# 使い方
`FluidPaint/FluidPaint.pde`  
を開いてください。  
これがプログラムの本体です。  
プログラムを起動して、マーカーをカメラに映して使います。  
マーカーは以下の4種類です。  
  
`FluidPaint-master/FluidPaint/data/marker/1024x1024/canvas_pic.png`  
キャンバスマーカーです。  
空間に描いた絵を回転できます。  
  
`FluidPaint-master/FluidPaint/data/marker/1024x1024/pen_pic.png`  
ペンマーカーです。  
空間に絵を描けます。  
  
`FluidPaint-master/FluidPaint/data/marker/1024x1024/eraser_pic.png`  
消しゴムマーカーです。  
カメラに映すと絵が全て消えます。  
  
`FluidPaint-master/FluidPaint/data/marker/1024x1024/fluid_pic.png`
流体マーカーです。  
空間に流体を発生させます。  
空間の絵は壁の役割をします。  
  
実際の動作画面の映像がFluidPaint-master/demoに入っています。  
  
また、このプログラムの起動には以下の3つのライブラリが必要になります。  

- nyar4psg
- video
- pixelflow

以下の方法に従ってライブラリを追加してください。  

# ライブラリの追加方法
Processingを立ち上げ、ウィンドウ上部の「ツール」より「ツールを追加...」を選択します。  
出てきたウィンドウの上部から「Libraries」を選択し、検索欄にライブラリ名と入力します。  
検索結果からインストールするライブラリをクリックし、右下のInstallボタンを押します。  
すでにライブラリがインストールされている場合は検索結果の左側にチェックマークが表示されます。  

# 正常に動作しない場合
## 起動しない場合
PCとの相性が悪い可能性があります。  
このプログラムは処理の一部にGPUを使用します。  
CPUやGPUのドライバとの相性により正常に動作しないことがあります。  

## 起動しない、もしくはカメラが表示されない場合
カメラが見つかっていない可能性があります。  
`FluidPaint-master/FluidPaint/ARManagement.pde`  
の49行目を  
`cam = new Capture(papplet, w, h);`  
から  
`cam = new Capture(papplet, w, h, XXX); // XXXは0以上のカメラ番号に書き換える`  
に変更してください。  

## 映像が左右逆に映る場合(鏡のようになっていない場合)
`FluidPaint-master/FluidPaint/FluidPaint.pde`  
の22行目を  
`final static boolean inverted_camera = true;`  
から  
`final static boolean inverted_camera = false;`  
に変更してください。  
