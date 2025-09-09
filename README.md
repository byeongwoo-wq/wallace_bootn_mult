# Booth wallace multiplier 
## 1. Booth 개념 
 Multiplicand(곱해지는 수), Multiplier (곱하는 수) 
 6×3=18 
 6: Multiplicand (반복해서 더해지는 수) 
 3: Multiplier (얼마나 더할지 결정하는 수)
 A. Multiplier (곱하는 수) 
  Multiplier의 비트 패턴을 분석하여 몇 번의 덧셈/뺄셈으로 곱셈을 줄일 수 있는지를 결정 
 B. Multiplicand (곱해지는 수) 
  Partial Product 생성을 위한 실제 연산 대상 인코딩 된 Multiplier 정보에 따라, 이 값을 +M, -M, +2M, -2M 등으로 조작합니다.
## 2.Wallace Tree 개념
 Wallace Tree는 여러 개의 Partial Product(부분 곱)을 빠르게 더하는 구조입니다. 일반적으로 Full Adder와 Half Adder를 계층적으로 구성하여 Carry Save Adder 방식으로 빠르게 합산합니다.  
## 3. 16bit Booth-Wallace tree multiplier 설계 방식
A. Booth 인코딩 (Radix-4) 
<img width="616" height="170" alt="image" src="https://github.com/user-attachments/assets/6f1c485c-ac49-40e0-b3e3-961376703684" />
  3비트씩 묶어서 Multiplier(Y)를 분석 → partial product 수를 절반으로 감소 
  16비트 Multiplier라면 (16/2) = 8개의 partial product가 생성됨
B. Partial Product 생성 
  Booth 인코딩 결과는 Multiplier의 위치(자리수)에 따라 결과를 왼쪽으로 시프트해야 함. 
  <img width="618" height="247" alt="image" src="https://github.com/user-attachments/assets/609b7ac8-4f85-407c-b557-0dabdc9f593f" />
C. Wallace Tree 합산 구조 
  모든 partial product의 각 비트 위치(column)를 수직으로 정렬 
  각 column에서 3개씩 묶어 Full Adder를 구성 (3:2 압축기) 
  남은 비트 수가 2개 이하가 될 때까지 반복 (Carry Save 방식) 
  마지막 2개의 행을 **Carry Propagate Adder(CPA)**로 처리 
D. 최종 Carry Propagate Adder (CPA) 
  Wallace Tree 결과로 나온 두 개의 32비트 결과를 최종 덧셈
