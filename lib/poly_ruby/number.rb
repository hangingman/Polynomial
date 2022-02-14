# coding: euc-jp
#module Number
#
#######################################
# K.Kodama(kodama@kobe-kosen.ac.jp) 2000-01-09
#
# This module is distributed freely in the sence of
# GPL(GNU General Public License).
#######################################

=begin
    Integer#odd
    Integer#even
    Complex#divmodE(other) # Complex Gauss integer divmod
    Complex#modE(other) # Complex Gauss integer divmod
        return quotient,remainder.
        quotient is Gauss integer
        i.e. both imaginal and real part are integer
        0<= r.abs < j2.abs

module Number
 TESTING:
    prime?(x)
         true if x is prime.
    kronecker(a,b)
      Kronecker-Jacobi synbol (a/b)
      Legendre symbol where b is odd prime
         -1: a is quadratic non-residue mod b
          0: a=0
          1: a is quadratic residue mod b. i.e. x^2=a mod p have 2 solutions.
    checkDivZ?(a,b,p)
         true if exist "k" s.t. (b+k*prime)|a
    spsp?(x,a)# Is prime or strong pseudo prime of base "a"?
    fpsp?(x,a)# Is prime or Fermat pseudo prime of base "a"?
    rabin_miller?(n)# Rabin-Miller pseudo prime
    spsp_o?(x,d,s,a)# x is prime or strong pseudo prime of base "a"?
       x-1=d*2^s
    testSquare(n) # return sqrti(n) if square, else return -1.
 ARITHMETIC:
     split_even(n) # return [d,s]  such that n=d*2^s.
     modP(n,p,fold=false) # 0<= modP <p , if fold, -p/2 < modP <= p/2
     rmodP(n,p,fold=false) # 0<= modP <p, if fold, -p/2 < modP <= p/2
          "n" admits Rational.
     divII(a,b)
        return a/b.
        If a,b are Interger, return Rational or Integer
     divFloor(a,b)
        return a/b rounded to Integer s.t. 0<=remainder< b.abs
        a,b be Integer,Rational or Float.
     divRound(a,b)
        return a/b rounded to Integer s.t. -b.abs/2<remainder<= b.abs/2
        a,b be Integer,Rational or Float.
     sqrti(n,p=0)
         If p==0,
             Integer square root
             return Integer x  s.t. x^2<=n<(x+1)^2 .
         else return sqrt mod p. -1 if n quadratic non-residue mod p.
             i.e. x^2==n mod p. 0<=x<p
     rooti(r,n)
         Integer r-th root of n where n,r positive Integer.
         return Integer i  s.t. i^r<=n<(i+1)^r
     cornacchia_p(p,d)
        Solve Diophantine equation x^2+dy^2=p.
        return [x,y].
        [0,0] if the solution does not exist.
        Assume 0<d<p, p:odd prime.
    cornacchia_4p(p,d)
       Solve Diophantine equation x^2+|D|y^2=4p.
       return integer solution [x,y].
       [0,0] if the solution does not exist.
       Assume that D==0,1 mod 4, -4p<D<0, p:odd prime.
    w4(d)
        w4(D): number of roots of unity in the quadratic order of discriminant D
        for x^2+|D|y^2=4p.
    lj0(ni,a,b)
        return x,y
        where x in Z/(ni Z) which Legendre-Jacobi symbol (x^3+ax+b, Ni) is 0 or 1
        y^2=x^3+ax+b
    j_invariant(r) # r=a+bi
       modular invariant of elliptic curve.
       j(r)=j(Er). Er=C/Lr and Lr is the lattice generated by 1 and r.
    hilbert_class_poly(D)
      Hilbert class polynomial of degree h(D) for the negative discriminant D.
      return monic polynomial h(D) in Z[x] of which j((D+sqrt(D))/2) is a root.
      D: negative discriminant ==1,0 mod 4

    nextPrime(n)
         prime next to n
    inv(n,p)
         return q s.t. nq=1 mod p. Note that p must be prime.
     powerMod(a,n,m)
         a^n modulo m. Same as powerI(a,n,m)
     powerI(a,n,m=0)
         a^n (if m=0), (a^n)%(m)(if m!=0). n: positive Integer
     primitive_root(p)
         primitive root modulo p.
     factorize(n)
         factorize n. return sorted list [p1,p2,p3,...]
 	  prime_factors(n,upperLimit=0)
         return [p1,p2,....] if upperLimit==0
         return m,[p1,p2,....] if upperLimit!=0.
               m is co-factor along [p1,p2...]
         sorted list of prime p dividing n upto "upperLimit"
         list __all__ prime factors if upperLimit==0.
     v(p,s)
         number of times that the prime p occurs in s.
     getDivisors(n)
        get all divisors of n (1 and n are included).
        return list [d1,d2,d3,...]
     gcd(a,b,c,...) or gcd([a,b,c,...])
         greatest common divisor
     gcd2(a,b,c,...) or gcd2([a,b,c,...])
         return gcd,x,y,z,..  s.t. gcd=a*x+b*y+c*z+...
     gcdC(a,b,c,...) or gcdC([a,b,c,...])
         complex GCD of Gauss Integer
     gcd2C(a,b,c,...) or gcd2C([a,b,c,...])
         complex GCD of Gauss integer
         return gcd,x,y,z,..  s.t. gcd=a*x+b*y+c*z+...
     lcm(a,b,c,...) or lcm([a,b,c,...])
        Least Common Multiple
     factorial(n)
         return n!
     comb(m,n)
         combination mCn
     perm(m,n)
         permutation mPn
     makePrimeList(n=3)
         make a list of primes up to n
         This set the list on Number::PrimeList[]
     digit_base(n,b)
		return number of digit of n in base b.
        i.e. return k such that b^(k-1) <= n < b^k.
     i_to_notation_array(i,b)
         return array of coefficients of notation of base b.
         i=c[n]b^n+c[n-1]b^(n-1)+...+c[0]  (i>=0)
     notation_array_to_i(c,b)
        reverse of above
     i_to_notation_factorial(i)
         return array of coefficients of notation of factorial base
         i=c[n]n!+c[n-1](n-1)!+...+c[2]2!+c[1]1!, c[0]=0  (i>=0)
     notation_factorial_to_i(c)
        reverse of above
     notation_str_to_i(str,b)
        convert string of notation base b to integer
     i_to_notation_str(i,b)
        convert integer to string of notation base b
 PRINTING:
    factor2s(factor,sep=" ")
        return string representation for result of "factorize"
        Example.
        (1) s=factor2s(f)
        (2) s=factor2s(f,"*")
        (3) s="("+  factor2s(f,  ")*("  )+  ")"
 CONSTANT
   Infinity
   Inf_IEEE754
   NaN_IEEE754
=end

require "rational"
require "complex"
require "poly_ruby/infinity"


class Complex
	# return quotient,remainder. quotient is Gauss integer
	# Gauss integer ring is a Euclidean domain with this function.
	def divmodE(other); return Number.divmodC(self,other); end
	def modE(other); q,r=Number.divmodC(self,other); return r; end
end

class Integer
	def odd; return self[0]==1; end
	def even; return self[0]==0; end
end;

module Number

	def Inf_IEEE754
		return 1.0/0.0;
	end
	# Inf_IEEE754=Object.new;

	def NaN_IEEE754
		return 0.0/0.0;
	end
	# NaN_IEEE754=Object.new;


	def modP(n,p,fold=false) # 0<= modP <p , if fold, -p/2 < modP <= p/2
		n=((n%p)+p)%p
		if fold&&(n*2 >p);n=n-p;end
		return n
	end


	def rmodP(n,p,fold=false) # 0<= modP <p, if fold, -p/2 < modP <= p/2
		if n.kind_of?(Rational);d=n.denominator; n=n.numerator * inv(d,p);end
		return modP(n,p,fold)
	end


	def divII(a,b) # return a/b
		if a.kind_of?(Integer)&&b.kind_of?(Integer);
			q=a.div(b)
			if a==(b*q); return q;
			elsif defined? Rational; return Rational(a,b);
			else; return a.to_f/b.to_f;
			end
		else
			# a or b is an element of field ?
			q=a/(b);
		end
		qi=q.to_i; if a==(qi*b); return qi;end
		return q
	end


	def divFloor(a,b) # divide s.t. quotient is Integer, 0<=remainder< b.abs
		q=(a/b).to_i; while a>(b*q); q=q+(b<=>0); end; while a<(b*q); q=q-(b<=>0); end;
		return q
	end

	def divRound(a,b) # divide s.t. quotient is Integer, -b.abs/2<remainder< b.abs/2
		q=divFloor(a,b); if (a-b*q)*2>b.abs; q=q+(b<=>0);end
		return q
	end

	def divmodC(j1,j2) # j1,j2 be Complex
		# return quotient,remainder. quotient is Gauss integer
		j11=Complex(j1); j21=Complex(j2)
		jc=j11*j21.conjugate; a2=j21.abs2
		q=Complex(Number.divRound(jc.real,a2),Number.divRound(jc.image,a2))
		r=j11-j21*q
		return q,r
	end


	def sqrti(n,p=0)
		if p==0; # Integer s.t. i^2<=n<(i+1)^2
			n=n.to_i; if n<=0;return 0; elsif n<=3;return 1; end
			x=n>>1; y=2; while y<x; x=(x+y)>>1; y=n.div(x); end
			return x
		else # x^2==n mod p. 0<=x<p. return -1 if n is not quadratic.
			if n<0; n=p-(-n)%p; end;
			n=n%p
			if n==0; return 0; end
			q=p-1; e=0;
			while (q&1==0); e+=1; q=q>>1; end # p-1=q*2^e
			1.upto(p-1){|n1| if kronecker(n1,p)==-1; break; end}
			z=powerMod(n,q,p)
			y=z; r=e; x=powerMod(n,(q-1).div(2),p); b=(n*x*x)%p; x=(n*x)%p
			loop{
				if b%p==1; return x; end;
				m=0; bm=b%p; while (bm!=1); bm=(bm*bm)%p; m+=1; end
				if m==r; return -1;end
				t=y%p; (r-m-1).times{t=(t*t)%p} #t=y^(2^(r-m-1))
				y=(t*t)%p; r=m%p; x=(x*t)%p; b=(b*y)%p
			}
		end;
	end


	def rooti(r,n)
		# Integer r-th root of n, s.t. x^r<=n<(x+1)^r for n,r positive Integer
		r=r.to_i; if r==1;return n; elsif r<1; return 0;elsif r==2; return sqrti(n);end
		n=n.to_i; if n<=0; return 0;elsif n<1<<r; return 1;end
		r1=r-1
		y=x=1; while y<n; x=x<<1; y=y<<r;end
		y=n.div(x**r1); while y<x; x=(r1*x+y).div(r);y=n.div(x**r1);end
		return x
	end


	SQT11=[].fill(0,0..10); for k in 0..10; SQT11[(k*k)%11]=1;end
	SQT63=[].fill(0,0..62); for k in 0..31; SQT63[(k*k)%63]=1;end
	SQT64=[].fill(0,0..63); for k in 0..31; SQT64[(k*k)%64]=1;end
	SQT65=[].fill(0,0..64); for k in 0..32; SQT65[(k*k)%65]=1;end

	def testSquare(n) # return sqrti(n) if square, else return -1.
		if n<0;return -1;elsif n==0;return 0;end
		if SQT64[n%64]==0;return -1;end
		r=n%45045
		if SQT63[r%63]==0;return -1;end
		if SQT65[r%65]==0;return -1;end
		if SQT11[r%11]==0;return -1;end
		s=sqrti(n);
		if n==s*s; return s; else return -1;end
	end

	def split_even(n) # return [d,s]  such that n=d*2^s.
		s=0; d=n-1; while d[0]==0; s=s+1; d=d>>1;end
		return d,s
	end;

	def spsp_o?(x,d,s,a)
		# x is prime or strong pseudo prime of base "a"?
		# x-1=d*2^s
		ad=powerMod(a,d,x) # ad=(a**d)%x
		if ad==1;return true;end
		x1=x-1
		for r in 0..s-1
			if ad==x1;return true;end
			ad=(ad*ad)%x ;# ad=a**(d*2**r)
		end
		return false
	end;

	def spsp?(x,a) # is prime or strong pseudo prime of base "a"?
		d,s=split_even(x); return spsp_o?(x,d,s,a)
	end

	def fpsp?(x,a) # is prime or Fermat pseudo prime of base "a"?
		# return (a**(x-1)%x == 1)
		return powerMod(a,x-1,x)==1
	end

	def rabin_miller?(n) # Rabin-Miller pseudo prime
		if n==2; return true; elsif n<2; return false; end
		q,t=split_even(n)
		p=2
		20.times{
			if n==p; return true;
			elsif n%p==0; return false;
			elsif not Number.spsp_o?(n,q,t,p); return false;
			end;
			p=Number.nextPrime(p)
		}
		return true
	end;

	def prime?(x)
		if x&1==0; if x==2; return true;else return false;end
		elsif x%3==0; if x==3; return true;else return false;end
		elsif x%5==0; if x==5; return true;else return false;end
		elsif x%7==0; if x==7; return true;else return false;end
		elsif x%11==0; if x==11; return true;else return false;end
		elsif x%13==0; if x==13; return true;else return false;end
		elsif x<2; return false
		end
		if (x>1000000000)&&(not fpsp?(x,13));return false;end
		d=sqrti(x)
		#r1=5; r2=7  # \pm 1 (mod 6)
		#r1=11; r2=13
		r1=17; r2=19
		while r1<=d
			if x%r1==0;return false; elsif x%r2==0;return false; end
			r1=r1+6; r2=r2+6
		end
		return true;
	end



	# make a table of primes
	PrimeList=[2,3];

	def makePrimeList1(n=3)
		# Simple but very slow.
		primeMax=PrimeList[PrimeList.length-1]
		if primeMax<3;PrimeList.clear;PrimeList<<[2,3]; primeMax=3;end
		i=primeMax
		while primeMax<n
			i=i+2
			if prime2?(i); PrimeList.push(i);primeMax=i;end
		end
	end


	def makePrimeList2(n=3)
		# Eratosthenes's sieve
		sieveErato=[]; sieveErato.fill(0,0..n)
		# sieveErato[0]=1;sieveErato[1]=1;
		i=4;step=2;while i<=n; sieveErato[i]=1;i=i+step; end ## mark even
		PrimeList.clear;PrimeList[0]=2; primeMax=2
		p=3
		while p<=n
			if sieveErato[p]==0;
				PrimeList.push(p); primeMax=p
				i=p*p # p*k (k<p) is already marked.
				step=p+p # assume p is odd, so step be even
				while i<=n; sieveErato[i]=1;i=i+step; end
			end
			p=p+2
		end
		primeMax=nextPrime(primeMax); PrimeList.push(primeMax)
	end


	def makePrimeList3(n=3)
		# Expand PrimeList using Eratosthenes sieve.
		# sieveErato[] omit less than primeMax using index (i-primeMax).
		primeMax=PrimeList[PrimeList.length-1]
		if n%2==0;n=n+1;end; if n<=primeMax;return;end
		shift=primeMax; ns=n-shift
		sieveErato=[]; sieveErato.fill(0,0..ns) # Note that sieveErato[] is shifted
		PrimeList.each{|p|
			if p*p>n;break;end
			if p%2==0;
				i=(primeMax+1);step=2 # Assume primeMax be odd.
			else
				i=p*p;step=p+p; if i<primeMax;i=i+((primeMax-i).div(step)+1)*step;end
			end
			i=i-shift;while i<=ns; sieveErato[i]=1;i=i+step; end
		}
		p=primeMax+2
		while p<=n
			if sieveErato[p-shift]==0;
				PrimeList.push(p); primeMax=p
				i=p*p # p*k (k<p) is already marked.
				step=p+p # assume p is odd, so step be even
				i=i-shift;while i<=ns; sieveErato[i]=1;i=i+step; end
			end
			p=p+2
		end
		primeMax=nextPrime(primeMax); PrimeList.push(primeMax)
	end


	def makePrimeList4(n=3)
		# Expand PrimeList using Eratosthenes's sieve.
		# sieveErato[] omit less than primeMax and even using index (i-primeMax)/2.
		primeMax=PrimeList[PrimeList.length-1]
		if n%2==0;n=n+1;end; if n<=primeMax;return;end
		shift=primeMax; ns=(n-shift).div(2)
		sieveErato=[]; sieveErato.fill(0,0..ns) # shifted and abbrevated
		PrimeList.each{|p|
			if p*p>n;break;end
			if p%2==1;
				i=p*p;step=p+p; if i<primeMax;i=i+((primeMax-i).div(step)+1)*step;end
				i=(i-shift).div(2);step=step.div(2);while i<=ns; sieveErato[i]=1;i=i+step; end
			end
		}
		p=primeMax+2
		while p<=n
			if sieveErato[(p-shift).div(2)]==0;
				PrimeList.push(p); primeMax=p
				i=p*p # p*k (k<p) is already marked.
				step=p # assume p is odd, so step be even
				i=(i-shift).div(2);while i<=ns; sieveErato[i]=1;i=i+step; end
			end
			p=p+2
		end
		primeMax=nextPrime(primeMax); PrimeList.push(primeMax)
	end


	def makePrimeList(n=3)
		makePrimeList4(n)
	end


	def prime2?(x)
		# Using PrimeList but slow.
		if x%2==0;if x==2;return true;else return false;end;end
		primeMax=PrimeList[PrimeList.length-1]
		if x<=primeMax;
			n1=0; n2=PrimeList.size
			while n1+1<n2
				n3=(n1+n2).div(2); p=PrimeList[n3]
				if p<x;n1=n3;elsif p>x; n2=n3;else return true;end
			end
			return false
		else
			d=sqrti(x); if d%2==0; d=d-1;end
			makePrimeList(d)
			PrimeList.each{|r|
				if r>d; return true; elsif x%r==0; return false; end
			}
			return true
		end
	end



	def nextPrime(n)
		# return prime next to n
		if n<2;return 2;end
		n=n+1; if (n%2==0);n=n+1;end
		while ! prime?(n); n=n+2; end;
		return n
	end


	def inv1(g,p)
		# p:prime then  g*inv(g,p)=1 (mod p)
		# g^p=g mod p (Fermat theorem)
		# i.e. g^(p-1)=g^(-2)
		g=((g%p)+p)%p; return (g**(p-2))%p
	end


	def inv2(g,p)
		## calculate g^(p-2) using binary notation of p-2.
		## It loop log_2(n) times.
		g=((g%p)+p)%p; gi=1;  ge=g;  ps=p-2;
		while ps != 0
			if ps%2==1; gi=(gi*ge) % p; ps=ps-1; end
			ps=ps.div(2); ge=(ge*ge) % p;
		end
		return  gi;
	end


	def inv3(g,p)
		# p:prime then  g*inv(g,p)=1 (mod p)
		# gx==1(p) means  gx+py=1.
		# The following is based on Euclides method.
		# In worst case, it loops n times when ((1+sqrt(5))/2)^n=p. (c.f. Fibonatti progression)
		# but, it works good.
		a=((g%p)+p)%p; b=p; x=1;u=0;
		while a != 1; q=b.div(a); a,x,b,u=b,u,b-q*a,u-q*x; end
		return ((x%p+p)%p)
	end


	def inv(g,p)
		return inv1(g,p)
	end

	def primitive_root(p) # primitive root modulo p.
		primes=prime_factors(p-1);
		for a in 2..p-1
			f=true
			primes.each{|q| if 1==(a**((p-1)/q)%p) then f=false;break; end}
			if f then return a; end;
		end;
	end;


	def powerMod(a,power,m)# a^power modulo m. power>=0
		return powerI(a,power,m)
	end;

	def powerI(a,n,m=0) #n: positive Integer. a^n (if m=0), (a^n)%(m)(if m!=0).
		if m==0
			s=1
			while n>0
				if n[0]==1; s=s*a; end
				a=a*a; n>>=1
			end
			return s;
		else
			s=1
			while n>0
				if n[0]==1; s=(s*a)%m; end
				a=(a*a)%m; n>>=1
			end
			return s;
		end
	end;

	def checkDivZ?(a,b,p) # true if exist "k" s.t. (b+k*prime)|a in Z
		a=a.abs; b=b.abs%p
		if b==0; return a%p==0; end
		while a%p==0; a=a.div(p);end;
		# x==b or x==-b mod p <=> (x-b)(x+b)==0 mod p <=> x^2==b^2 mod p
		b2=(b*b)%p
		if a<2500
			if (a*a)%p==b2; return true; end
			## (b+k*prime)=-a.div(2) then k=(-a.div(2)-b).div(p), (b+k*prime)=a.div(2) then k=(a.div(2)-b).div(p)
			for k in (-a.div(2)-b).div(p)..(a.div(2)-b).div(p); if a%(b+k*p)==0;return true;end; end
			return false
		elsif a<1000000
			sqrt=sqrti(a); d=1+(a%2); i=1
			while i<=sqrt
				if a%i==0
					if (i*i)%p==b2; return true; end
					ai=a.div(i)
					if (ai*ai)%p==b2; return true; end
				end
				i=i+d
			end
		else
			div=getDivisors(a)
			for i in 0..div.size-1
				d=div[i]; if (d*d)%p == b2; return true;end
			end
		end
		return false
	end


	KroneckerTbl=[0,1,0,-1,0,-1,0,1] # (-1)^((i^2-1)/8)  i:odd

	def kronecker(a,b)
		# Kronecker-Jacobi synbol (a/b)
		# Legendre symbol where b is odd prime
		# test b==0
		if b==0; if a.abs==1; return 1;else return 0;end;end
		# remove power of 2 from b
		if (a&1==0)&&(b&1==0);return 0;end
		v=0; while b&1==0; v=v+1; b=b.div(2); end
		if a<0; a=b-(-a)%b; end
		if v&1==0; k=1; else k=KroneckerTbl[a&7]; end;
		if b<0; b=-b;end
		#if a<0; k=-k;end
		# reduce size.  Note that b:odd >0
		a=a%b
		loop{
			if a==0; if b>1;return 0;else return k;end;end
			# remove powers of 2 from a
			v=0; while a&1==0; v=v+1; a=a.div(2);end
			if v&1==1; k=KroneckerTbl[b&7]*k;end
			# subtract, apply reciprocity.   a,b: odd
			r=b-a
			if r>0; if a&b&2==2; k=-k;end; b=a; a=r;
			else a=-r;
			end
		}
	end


	def cornacchia_p(p,d)
		# Solve Diophantine equation x^2+dy^2=p.
		# return [x,y].
		# return [0,0] if the solution does not exist
		# 0<d<p
		k=kronecker(p-d,p); if k==-1; return [0,0]; end
		x=sqrti(p-d,p); if x0+x0<p; x0=p-x0; end;
		a=p; b=x0; l=Number.sqrti(p)
		while b>l; r=a%b; a=b; b=r; end
		pb=p-b*b; if pb%d!=0; return [0,0];end;
		c=testSquare(pb/d); if c<0; return [0,0];end;
		return [b,c]
	end;

	def cornacchia_4p(p,d)
		# return integer solution (x,y) for Diophantine equation x^2+|D|y^2=4p
		# return [0,0] if the solution does not exist
		# Assume that D==0,1 mod 4, D<0, |D|<4p, p:prime
		dm=(-d)%4;
		if !((d<0)and(-d<p*4)and((dm==0)or(dm==3)));
			raise sprintf("bad argument: p=%d, d=%d\n", p,d);
		end;
		if p==2;
			q=testSquare(d+8); if q>0 then return [q,1]; else return [0,0]; end
		end
		k=kronecker(d,p); if k==-1; return [0,0]; end
		x0=sqrti(d,p); if (x0&1)!=(d&1); x0=p-x0; end;
		a=p*2; b=x0; l=sqrti(p*4)
		while b>l; r=a%b; a=b; b=r; end; # Euclidian algorithm until b<=l
		pb=p*4-b*b; if (pb)%(-d)!=0; return [0,0]; end
		c=testSquare(pb/(-d)); if c<0;  return [0,0]; end
		return [b,c]
	end

	def w4(d)
		# w(D): number of roots of unity in the quadratic order of discriminant D
		if d<-4; return 2;
		elsif d==-4; return 4;
		elsif d==-3; return 6;
		else printf "w(%d): Note that D==0,1 mod 4, D<0.\n", d; #
			raise "error in w(d)"
		end;
	end;

	def lj0(ni,a,b)
		# return x,y
		# where x in Z/(ni Z) which Legendre-Jacobi symbol (x^3+ax+b, Ni) is 0 or 1
		# y^2=x^3+ax+b
		0.upto(ni-1){|x|
			fx=(x*x+a)*x+b
			if 0<=Number.kronecker(fx,ni);
				y=Number.sqrti(fx,ni);
				return x,y;
			end;
		}
		return 0,0
	end;

	def j_delta(r)
		q=Math.exp(r*2*MathExt::pi*Complex::I); d=Complex.new(0.0)
		n=1; loop{
			q1=Number.powerI(q,(n*(3*n-1)).div(2))+Number.powerI(q,(n*(3*n+1)).div(2))
			if d+q1==d; break; end
			if n.odd; d-=q1; else d+=q1; end
			n+=1;
		}
		d=q*Number.powerI(d+1,24);
		return d
	end

	def j_invariant(r) # r=a+bi
		# j(r)=j(Er). Er=C/Lr and Lr is the lattice generated by 1 and r.
		# modular invariant of elliptic curve.
		f=j_delta(r*2)/j_delta(r); s=Number.powerI(256*f+1,3)/f; return s.real.round
	end;

=begin
		 # test j
		 r=Complex(1.0,Math.sqrt(3.0)); printf "j(%s)=%s\n",r, Number.j_invariant(r)
		 r=Complex(0.0,1.0); printf "j(%s)=%s\n",r, Number.j_invariant(r)
		 r=Complex(1.0,Math.sqrt(7.0));r=r/2.0; printf "j(%s)=%s\n",r, Number.j_invariant(r)
		 r=Complex(0.0,Math.sqrt(2.0)); printf "j(%s)=%s\n",r, Number.j_invariant(r)
		 #j(1.0+1.732050808i)=54000
		 #j(1.0i)=1728
		 #j(0.5+1.322875656i)=-3375
		 #j(1.414213562i)=8000
=end


	def hilbert_class_poly(d)
		# Hilbert class polynomial of degree h(D) for the negative discriminant D.
		# return monic polynomial h(D) in Z[x] of which j((D+sqrt(D))/2) is a root.
		# d: negative discriminant ==1,0 mod 4
		x=Polynomial("x")
		p=1; b=d%2; bb=Number.sqrti((-d).div(3))
		loop{
			#2
			t=(b*b-d).div(4); a=[b,1].max
			loop{
				#3
				if t%a==0;
					j=Number.j_invariant(Complex(-b.to_f,Math.sqrt(-d.to_f))/(a*2.0))
					if (a==b)or(a*a==t)or(b==0); p=(x-j)*p;
					else p=(x*x-2*j.real*x+j.abs2)
					end
				end
				#4
				a+=1;
				if a*a>t; break;end;
			}
			#5
			b=b+2;
			if b>bb; break; end
		}
		p.coeff_round;
		return p
	end;

=begin
		 d=-8
		 #d=-7
		 # j((D+sqrt(D))/2) is a root of the polynomial
		 j=Number.j_invariant(Complex(d.to_f,Math.sqrt(-d.to_f))/2.0)
		 f=hilbert_class_poly(d)
		 printf "f=h(%s)=%s, f(%s)=%s\n",d,f, j,f.substitute(j)
=end


	def factorize(n)
		# factorization
		n=n.abs
		f=[]
		while n%2==0; f.push(2); n=n>>1; end
		while n%3==0; f.push(3); n=n.div(3); end
		r1=5; r2=7 # r=\pm 1 (mod 6). So, step s is \pm 2(mod 6).
		d=sqrti(n)
		while (r1<=d)
			if n%r1==0;while n%r1==0; f.push(r1); n=n.div(r1);end; d=sqrti(n); end
			if n%r2==0;while n%r2==0; f.push(r2); n=n.div(r2);end; d=sqrti(n); end
			r1=r1+6; r2=r2+6
		end
		if (n != 1)||(f==[]); f.push(n);end
		return f
	end


	def factor2s(factor,sep=" ")
		s="";sp=""
		factor.each{|x| s=s+sp+x.to_s; sp=sep}
		return s
	end

	def prime_factors(n,upperLimit=0) # list of prime p dividing n
		if upperLimit==0;
			n=n.abs
			f=[]
			if n%2==0; f.push(2); while n%2==0;n=n>>1; end; end
			if n%3==0; f.push(3); while n%3==0; n=n.div(3); end; end
			r1=5; r2=7 # r=\pm 1 (mod 6). So, step s is \pm 2(mod 6).
			d=sqrti(n)
			while (r1<=d)
				if n%r1==0;f.push(r1);
					while n%r1==0; n=n.div(r1);end; d=sqrti(n);
				end
				if n%r2==0;f.push(r2);
					while n%r2==0; n=n.div(r2);end; d=sqrti(n);
				end
				r1=r1+6; r2=r2+6
			end
			if n!=1; f.push(n);end
			return f
		else
			n=n.abs
			f=[]
			if n%2==0; f.push(2); while n%2==0;n=n>>1; end; end
			if n%3==0; f.push(3); while n%3==0; n=n.div(3); end; end
			r1=5; r2=7 # r=\pm 1 (mod 6). So, step s is \pm 2(mod 6).
			d=sqrti(n)
			while (r1<=d)and(r1<=upperLimit)
				if n%r1==0;f.push(r1);
					while n%r1==0; n=n.div(r1);end; d=sqrti(n);
				end
				if n%r2==0;f.push(r2);
					while n%r2==0; n=n.div(r2);end; d=sqrti(n);
				end
				r1=r1+6; r2=r2+6
			end
			if (r1>d)&&(n!=1); f.push(n); n=1;end
			return n,f
		end
	end


	def v(p,s) # v(p,s): number of times that the prime p occurs in s.
		n=0
		while true;
			s,r=s.divmod(p)
			if r==0 then n=n+1; else return n; end;
		end
	end;


	def getDivisorsS(i,divisor,factors,factord)
		if i>=factors.size; return [divisor];end
		divisors=[]
		for j in 0..factord[i]
			divisors = divisors + getDivisorsS(i+1,divisor,factors,factord)
			divisor *= factors[i]
		end
		return divisors
	end

	def getDivisors(n)
		# get all divisors of n
		factors=Number.factorize(n)
		factord=[1]; i=0;
		while i<factors.size
			if factors[i]==factors[i+1]; factord[i] += 1; factors.delete_at(i+1);
			else i=i+1; factord[i]=1
			end
		end
		return getDivisorsS(0,1,factors,factord)
	end



	def gcdS(a,b)
		while true
			if b==0 ; return a;end
			a=a%b
			if a==0 ; return b;end
			b=b%a
		end
	end


	def gcd(a,*b) # gcdS の wrapper
		case a
		when Array;
		when Integer; a=[a]+b
		else  raise TypeError
		end
		g=0; a.each{|x| g=gcdS(x,g)}
		return g
	end


	def gcd2s(a,b)
		# a,b に対し gcd(a,b)= ax+by となる x,y を gcd とともに求める.
		# a_= xa+yb, b_= ua+vb と書くと
		# a=1a+0b, b=0a+1b から始めて...
		x=1; y=0; u=0;v=1
		while true
			if b==0;return a,x,y;end
			q=a.div(b); a=a-q*b; x=x-q*u; y=y-q*v
			if a==0;return b,u,v;end
			q=b.div(a); b=b-q*a; u=u-q*x; v=v-q*y
		end
	end



	def gcd2(a,*b) # gcd2s の wrapper
		case a
		when Array;
		when Integer; a=[a]+b
		else  raise TypeError
		end
		# a[] の gcd と
		# gcd=a[0]*xj[0]+a[1]*xj[1]+...+a[n]*xj[n] となる係数 xj[] を返す.
		g=0; xj=[]; # gcd up to i
		a.each{|b|
			g,x,y=gcd2s(b,g)
			xj.each_index{|j| xj[j]=xj[j]*y}
			xj.push(x)
		}
		return g,*xj
	end


	def gcdSC(a,b)
		while true
			if b==0 ; return a;end
			q,a=divmodC(a,b)
			if a==0 ; return b;end
			q,b=divmodC(b,a)
			printf "%s %s\n",a,b,q
		end
	end

	def gcdC(a,*b) # wrapper of gcdSC
		# complex GCD of Gauss integer
		case a
		when Array;
		when Complex; a=[a]+b
		else  raise TypeError
		end
		g=Complex(0); a.each{|x| g=gcdSC(x,g)}
		return g
	end


	def gcd2sC(a,b)
		# a,b に対し gcd(a,b)= ax+by となる x,y を gcd とともに求める.
		# a'= xa+yb, b'= ua+vb と書くと
		# a=1a+0b, b=0a+1b から始めて...
		x=Complex(1); y=Complex(0); u=Complex(0);v=Complex(1)
		while true
			if b==0;return a,x,y;end
			q,a=divmodC(a,b); x=x-q*u; y=y-q*v
			if a==0;return b,u,v;end
			q,b=divmodC(b,a); u=u-q*x; v=v-q*y
		end
	end


	def gcd2C(a,*b) # gcd2sC の wrapper
		# complex GCD of Gauss integer
		case a
		when Array;
		when Integer; a=[a]+b
		else  raise TypeError
		end
		# a[] の gcd と
		# gcd=a[0]*xj[0]+a[1]*xj[1]+...+a[n]*xj[n] となる係数 xj[] を返す.
		g=Complex(0); xj=[]; # gcd up to i
		a.each{|b|
			g,x,y=gcd2sC(b,g)
			xj.each_index{|j| xj[j]=xj[j]*y}
			xj.push(x)
		}
		return g,*xj
	end

	def lcm(a,*b)
		case a
		when Array;
		when Integer; a=[a]+b
		else  raise TypeError
		end
		l=1; a.each{|x| l=l*(x.div(gcdS(l,x)))}
		return l.abs
	end


	def factorial(n)
		k=1; for i in 2..n; k *= i;end; return k
	end

	def comb(m,n) # combination
		return (factorial(m).div(factorial(n))).div(factorial(m-n))
	end

	def perm(m,n) # permutation
		return factorial(m).div(factorial(m-n))
	end

	def digit_base(n,b)
		# return digit of n in base b. i.e. return k such that b^(k-1) <= n < b^k.
		if n<0 then n=-n; end;
		k=1; m=1
		while(m<n); k=k+1; m=m*b; end;
		return k;
	end;

	def i_to_notation_array(i,b)
        # return array of coefficients of notation of base b.
        # i=c[n]b^n+c[n-1]b^(n-1)+...+c[0]  (i>=0)
 		i=i.abs
		if i==0;return [1];end
		c=[]
		while i>0; c.push(i%b); i=i.div(b); end
		return c
	end


	def i_to_notation_factorial(i)
        # return array of coefficients of notation of factorial base
        # i=c[n]n!+c[n-1](n-1)!+...+c[2]2!+c[1]1!, c[0]=0  (i>=0)
 		i=i.abs
		if i==0;return [1];end
		c=[0];b=2
		while i>0; c.push(i%b); i=i.div(b);b=b+1; end
		return c
	end


	def notation_array_to_i(c,b)
		i=0; d=c.size-1
		while d>=0; i=i*b+c[d];d=d-1; end
		return i
	end


	def notation_factorial_to_i(c)
		# notation_factorial(i) の逆
		i=0; d=c.size-1
		while d>=1; i=(i+c[d])*d;d=d-1; end
		return i
	end

	NotationCharS="0123456789abcdefghijklmnopqrstuvwxyz"
	NotationCharA=NotationCharS.split("")
	NotationCharRH={}; NotationCharA.each_with_index{|c,i| NotationCharRH[c]=i}

	def notation_str_to_i(str,b)
		c=[]
		str.downcase.split("").reverse_each{|v| c.push(NotationCharRH[v])}
		return notation_array_to_i(c,b)
	end

	def i_to_notation_str(i,b)
		str=""; i_to_notation_array(i,b).each{|v| str=NotationCharA[v]+str}
		return str
	end

	module_function :Inf_IEEE754, :NaN_IEEE754
	module_function :divII,:divFloor,:divRound,:divmodC
	module_function :inv,:inv1,:inv2,:inv3,:checkDivZ?,:modP,:rmodP,:primitive_root,:powerMod,:powerI
	module_function :prime?,:prime2?,:nextPrime
	module_function :split_even, :spsp?, :spsp_o?, :fpsp?, :rabin_miller?
	module_function :kronecker
	module_function :sqrti,:testSquare,:rooti
	module_function :cornacchia_p,:cornacchia_4p, :w4, :lj0
	module_function :makePrimeList
	module_function :makePrimeList1,:makePrimeList2,:makePrimeList3,:makePrimeList4
	module_function :gcd,:gcdS,:gcd2,:gcd2s
	module_function :gcdC,:gcdSC,:gcd2C,:gcd2sC
	module_function :lcm
	module_function :factorize,:factor2s,:getDivisors,:getDivisorsS,:prime_factors,:v
	module_function :factorial, :comb, :perm
	module_function :digit_base,:i_to_notation_array,:i_to_notation_factorial
	module_function :notation_array_to_i,:notation_factorial_to_i
	module_function :i_to_notation_str,:notation_str_to_i
	module_function :j_invariant, :j_delta,:hilbert_class_poly
end # module Number
