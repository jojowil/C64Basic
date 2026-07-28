package BASIC;

import java.util.EmptyStackException;

public class Expr {
    private static class GenStack<T> {
        // the top of the stack
        private Node top;
        private int size;

        private class Node {
            private T data;
            private Node next;

            private Node(T item) {
                data = item;
                next = null;
            }
        }

        public GenStack () {
            top = null;
            size = 0;
        }

        // returns the top value or exception when empty.
        public T peek() {
            if (isEmpty())
                throw new EmptyStackException();
            else
                return top.data;
        }

        // push new item on the top
        public void push(T item) {
            Node n = new Node(item);
            n.next = top;
            top = n;
            size++;
        }

        // remove item from the top and return the removed value.
        public T pop() {
            T v;
            if ( isEmpty() )
                throw new EmptyStackException();
            v = top.data;
            top = top.next;
            size--;
            return v;
        }

        // debug method to dump the contents of the stack to the screen
        public String toString() {
            Node p = top;
            String s = "";

            while ( p != null ) {
                s = s + p.data + "\n";
                p = p.next;
            }
            return s;
        }

        // method to determine if the stack is empty.
        public boolean isEmpty() {
            return top == null;
        }

        // method to return the number of frames
        public int size() {
            return size;
        }

        // main method to test the class
        public static void main(String[] args) {
            GenStack<Integer> s = new GenStack<>();

            s.push(7);
            s.push(5);
            s.push(3);
            System.out.println("Stack length is " + s.size());
            System.out.println("Stack contains:\n" + s);

            while (! s.isEmpty()) {
                System.out.println("Popped " + s.pop());
            }

            // intentially try to pop an empty stack
            try {
                System.out.println("Popped " + s.pop());
            } catch (EmptyStackException e) {
                System.out.println("That could have been bad!");
            }
        }
    }

    public static void apply(GenStack<Character> os, GenStack<Integer> vs) {

        int	v1, v2, r;
        char	op;

        op = os.pop();
        v2 = vs.pop();
        v1 = vs.pop();

        switch (op) {

            case '+':
                vs.push(v1 + v2);
                break;

            case '-':
                vs.push(v1 - v2);
                break;

            case '/':
                vs.push(v1 / v2);
                break;

            case '*':
                vs.push(v1 * v2);
                break;

            case '%':
                vs.push(v1 % v2);
                break;
        }
    }

    public static int eval(String s) {

        int	x=0, num;
        GenStack<Character> ostack = new GenStack<Character>();
        GenStack<Integer> vstack = new GenStack<Integer>();
        char c;

        while ( x < s.length()) {
            c = s.charAt(x);
            switch(c) {

                case '(':
                    ostack.push((char)c);
                    break;

                case ')':
                    while ( ostack.peek() != '(' )
                        apply(ostack, vstack);
                    ostack.pop();
                    break;

                case '0', '1', '2', '3', '4', '5', '6', '7', '8', '9':
                    num = 0;
                    while ( x < s.length() && Character.isDigit(c) ) {
                        num = num * 10 + (c - '0');
                        x++;
                        if ( x < s.length())
                            c = s.charAt(x);
                    }
                    x--;
                    vstack.push(num);
                    break;

                case '+', '-', '*', '/', '%':
                    if ( !ostack.isEmpty() )
                        while ( !ostack.isEmpty() && prec(ostack.peek()) >= prec(c))
                            apply(ostack, vstack);
                    ostack.push(c);
                    break;

                case ' ', '\t': break;
            }
            x++;
        }
        while ( ! ostack.isEmpty() )
            apply(ostack, vstack);

        return vstack.pop();
    }

    public static int prec (char c) {

        switch (c) {

            case '+', '-': return(0);
            case '*', '/', '%': return(1);
            case '(': return(-1);
        }

        return (-1);
    }
}
