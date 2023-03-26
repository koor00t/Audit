# jw-dream

## unchecked-transfer
### 설명
swap 함수
31 Line : tokenX.transferFrom(msg.sender,address(this),tokenXAmount)
32 Line : tokenY.transfer(msg.sender,outputAmount)
40 Line : tokenY.transferFrom(msg.sender,address(this),tokenYAmount)
41 Line : tokenX.transfer(msg.sender,outputAmount)

addLiquidity 함수
66 Line : tokenX.transferFrom(msg.sender,address(this),tokenXAmount)
67 Line : tokenY.transferFrom(msg.sender,address(this),tokenYAmount)

### 파급력
Impact: High

### 해결방안
SafeERC20을 사용하거나 transfer/transferFrom 반환값이 체크되어 있는지 확인한다.



## divide-before-multiply
### 설명
나눗셈을 한 결과값에 곱셈을 수행함.
swap 함수
26 Line : [outputAmount = yBalance * (tokenXAmount * 999 / 1000) / (xBalance + (tokenXAmount * 999 / 1000))]
35 Line : [outputAmount = xBalance * (tokenYAmount * 999 / 1000) / (yBalance + (tokenYAmount * 999 / 1000))]

### 파급력
Impact: Medium

### 해결방안
나눗셈을 하기전에 곱셈을 하는 로직을 고려한다.



## incorrect-equality
### 설명
공격자가 쉽게 조작할 수 있는 strict equalities를 사용한다.

addLiquidity 함수
54 Line : [totalLiquidity == 0]

### 파급력
Impact: Medium

### 해결방안
계정의 토큰 보유량을 확인하기 위해서 strict equality를 사용하면 안된다.


## reentrancy-no-eth
### 설명

### 파급력
### 해결방안

