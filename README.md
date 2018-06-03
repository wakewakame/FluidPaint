# Flued Paint  
### ディレクトリ配置  
- FluidPaint  
  - FluidPaint : プロジェクトディレクトリ  
    - data : リソース  
      - camera : カメラデータ  
      - marker : マーカーデータ  
			  - 1024x1024 : 高解像度のマーカー画像等、マーカー印刷用データ
      - shader : 流体を制御するシェーダ  
      - shader : 発表に使用するスライド  
	  - ARManagement.pde : nyar4psgのラッパークラス  
		- FluidPaint.pde : メイン  
		- Native.pde : PixelFlowのシェーダ周りのラッパークラス  
		- Particle.pde : 空間に描画するパーティクルのマネジメントクラス  
		- Slide.pde : 発表に使用するスライドを表示するクラス  
  - demo : デモ動画  

### 必要なライブラリ  
- nyar4psg  
- video  
- pixelflow  

### 注意  
OpenGLのバージョンやPC環境によって、シェーダがうまく動作しない可能性があります。  
PixelFlowの関数を使用している個所を削除すると解決するかもしれません。  
