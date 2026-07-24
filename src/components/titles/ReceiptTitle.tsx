type IProps = Readonly<{
  className?: string;
  title: string;
}>;

const ReceiptTitle = ({ title, className }: IProps) => {
  return (
    <h3
      className={`text-center text-[14px] font-normal uppercase tracking-[0.5px] ${className}`}
    >
      {title}
    </h3>
  );
};

export default ReceiptTitle;
